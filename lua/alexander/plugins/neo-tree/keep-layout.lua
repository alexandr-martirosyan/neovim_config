-- Keep window proportions when the neo-tree sidebar opens or closes.
--
-- Without this, the sidebar takes all of its width from the neighbouring window, and closing it
-- hands the space back unevenly, so custom layouts (50/50, 70/30, ...) get distorted.
-- Here, every window is scaled by the same factor instead:
--   open:  remember widths, then shrink every window proportionally to make room for the tree
--   close: restore the exact original widths, or (if you resized while the tree was open)
--          scale the current widths back up so your new proportions are kept
-- Windows with 'winfixwidth' (e.g. AI sidebars) keep their width. Heights are never touched.
local M = {}

-- Per tab page: { tree, before, after, closing = {[win] = width}, free, free_open, free_closing, free_after }
local state = {}

local function is_sidebar(position)
	return position == "left" or position == "right"
end

local function is_neo_tree(win)
	return vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "neo-tree"
end

-- Normal (non-floating) window that should be scaled.
local function is_scalable(win, tree)
	return win ~= tree
		and vim.api.nvim_win_get_config(win).relative == ""
		and not is_neo_tree(win)
		and not vim.wo[win].winfixwidth
end

-- Windows of a tab page that should be scaled.
local function scalable_windows(tab, tree)
	return vim.tbl_filter(function(win)
		return is_scalable(win, tree)
	end, vim.api.nvim_tabpage_list_wins(tab))
end

-- Columns used by the windows that are not scaled (the tree and fixed-width windows), counted
-- only for windows sitting directly in the given `winlayout()` row.
local function fixed_columns_in(row, tree)
	local used = 0
	for _, child in ipairs(row[2]) do
		if child[1] == "leaf" then
			local win = child[2]
			if win == tree or is_neo_tree(win) or vim.wo[win].winfixwidth then
				used = used + vim.api.nvim_win_get_width(win) + 1 -- + separator
			end
		end
	end
	return used
end

-- Same, for the top-level row of the layout (where neo-tree opens as a full-height sidebar).
local function fixed_columns(tab, tree)
	local layout = vim.fn.winlayout(vim.api.nvim_tabpage_get_number(tab))
	if layout[1] ~= "row" then
		return 0
	end
	return fixed_columns_in(layout, tree)
end

-- Width of a `winlayout()` node in columns (a row adds its children plus a separator between each).
local function node_width(node)
	if node[1] == "leaf" then
		return vim.api.nvim_win_get_width(node[2])
	elseif node[1] == "col" then
		return node_width(node[2][1])
	end
	local width = -1
	for _, child in ipairs(node[2]) do
		width = width + node_width(child) + 1
	end
	return width
end

-- The row that has `win` as a direct child. Not always the top level: a full-width split added
-- while the tree is open (e.g. `<leader>sD`) puts the tree's row inside a column.
local function parent_row(node, win)
	if node[1] == "leaf" then
		return nil
	end
	for _, child in ipairs(node[2]) do
		if node[1] == "row" and child[1] == "leaf" and child[2] == win then
			return node
		end
		local found = parent_row(child, win)
		if found then
			return found
		end
	end
end

local function leaves(node, out)
	out = out or {}
	if node[1] == "leaf" then
		table.insert(out, node[2])
	else
		for _, child in ipairs(node[2]) do
			leaves(child, out)
		end
	end
	return out
end

local function widths_of(wins)
	local widths = {}
	for _, win in ipairs(wins) do
		widths[win] = vim.api.nvim_win_get_width(win)
	end
	return widths
end

-- Set widths left to right; Vim gives the difference to the next window, so two passes settle it.
local function apply(targets)
	local wins = vim.tbl_keys(targets)
	table.sort(wins, function(a, b)
		return vim.api.nvim_win_get_position(a)[2] < vim.api.nvim_win_get_position(b)[2]
	end)
	for _ = 1, 2 do
		for _, win in ipairs(wins) do
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_set_width(win, math.max(1, targets[win]))
			end
		end
	end
end

local function scale(widths, factor)
	local targets = {}
	for win, width in pairs(widths) do
		targets[win] = math.floor(width * factor + 0.5)
	end
	return targets
end

function M.before_open(args)
	if not is_sidebar(args.position) then
		return
	end
	local tab = vim.api.nvim_get_current_tabpage()
	local wins = scalable_windows(tab)
	state[tab] = { before = widths_of(wins), free = vim.o.columns - fixed_columns(tab) }
end

function M.after_open(args)
	local tab = vim.api.nvim_get_current_tabpage()
	local s = state[tab]
	if not s or not is_sidebar(args.position) or not args.winid then
		return
	end
	s.tree = args.winid
	-- Run after neo-tree has finished sizing its own window.
	vim.schedule(function()
		if state[tab] ~= s or not vim.api.nvim_win_is_valid(s.tree) then
			return
		end
		local free_now = vim.o.columns - fixed_columns(tab, s.tree)
		if s.free <= 0 or free_now <= 0 then
			return
		end
		local before = {}
		for win, width in pairs(s.before) do
			if vim.api.nvim_win_is_valid(win) then
				before[win] = width
			end
		end
		apply(scale(before, free_now / s.free))
		s.after = widths_of(vim.tbl_keys(before))
		s.free_open = free_now
	end)
end

-- Measure the windows while the tree is still on screen (before Vim hands its space to a neighbour).
-- Only the windows in the tree's own row get its space back; windows outside it (a full-width split
-- below, for example) keep their width and are left alone.
local function capture(tab)
	local s = state[tab]
	if not (s and s.tree and vim.api.nvim_win_is_valid(s.tree) and not s.closing) then
		return
	end
	local row = parent_row(vim.fn.winlayout(vim.api.nvim_tabpage_get_number(tab)), s.tree)
	if not row then
		return
	end
	local wins = vim.tbl_filter(function(win)
		return is_scalable(win, s.tree)
	end, leaves(row))
	local width, fixed = node_width(row), fixed_columns_in(row, s.tree)
	s.closing = widths_of(wins)
	s.free_closing = width - fixed
	-- After closing, the row keeps its width and the tree's columns (+ separator) become free.
	s.free_after = width - fixed + vim.api.nvim_win_get_width(s.tree) + 1
end

function M.before_close(args)
	if is_sidebar(args.position) then
		capture(vim.api.nvim_get_current_tabpage())
	end
end

-- Restore after the tree is gone (called from neo-tree's close event or from WinClosed).
function M.restore(tab)
	local s = state[tab]
	state[tab] = nil
	if not s or not s.after or not s.closing or not vim.api.nvim_tabpage_is_valid(tab) then
		return
	end
	-- Same windows, untouched since opening: put back the exact original widths.
	local untouched = vim.tbl_count(s.closing) == vim.tbl_count(s.after)
	for win, width in pairs(s.closing) do
		if s.after[win] ~= width then
			untouched = false
		end
	end
	if untouched then
		apply(s.before)
		return
	end
	-- Layout changed while the tree was open: scale those proportions up to the freed width.
	local targets = {}
	for win, width in pairs(s.closing) do
		if vim.api.nvim_win_is_valid(win) then
			targets[win] = width
		end
	end
	if s.free_closing > 0 then
		apply(scale(targets, s.free_after / s.free_closing))
	end
end

function M.after_close(args)
	if is_sidebar(args.position) then
		M.restore(vim.api.nvim_get_current_tabpage())
	end
end

-- Closing the tree with :q skips neo-tree's close events; catch it here.
vim.api.nvim_create_autocmd("WinClosed", {
	group = vim.api.nvim_create_augroup("AlexanderNeoTreeKeepLayout", { clear = true }),
	callback = function(ev)
		local closed = tonumber(ev.match)
		for tab, s in pairs(state) do
			if s.tree == closed then
				capture(tab) -- runs before the window leaves the layout
				vim.schedule(function()
					M.restore(tab)
				end)
			end
		end
	end,
})

M.event_handlers = {
	{ event = "neo_tree_window_before_open", handler = M.before_open },
	{ event = "neo_tree_window_after_open", handler = M.after_open },
	{ event = "neo_tree_window_before_close", handler = M.before_close },
	{ event = "neo_tree_window_after_close", handler = M.after_close },
}

return M
