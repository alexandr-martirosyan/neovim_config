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

-- Per tab page: { tree, before, after, closing = {[win] = width}, free, free_open, free_closing }
local state = {}

local function is_sidebar(position)
	return position == "left" or position == "right"
end

local function is_neo_tree(win)
	return vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "neo-tree"
end

-- Normal (non-floating) windows of a tab page that should be scaled.
local function scalable_windows(tab, tree)
	local wins = {}
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
		if
			win ~= tree
			and vim.api.nvim_win_get_config(win).relative == ""
			and not is_neo_tree(win)
			and not vim.wo[win].winfixwidth
		then
			table.insert(wins, win)
		end
	end
	return wins
end

-- Columns used by the windows that are not scaled (the tree and fixed-width windows), counted
-- only for windows sitting directly in the top-level row of the layout.
local function fixed_columns(tab, tree)
	local layout = vim.fn.winlayout(vim.api.nvim_tabpage_get_number(tab))
	if layout[1] ~= "row" then
		return 0
	end
	local used = 0
	for _, child in ipairs(layout[2]) do
		if child[1] == "leaf" then
			local win = child[2]
			if win == tree or is_neo_tree(win) or vim.wo[win].winfixwidth then
				used = used + vim.api.nvim_win_get_width(win) + 1 -- + separator
			end
		end
	end
	return used
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
local function capture(tab)
	local s = state[tab]
	if s and s.tree and vim.api.nvim_win_is_valid(s.tree) and not s.closing then
		s.closing = widths_of(scalable_windows(tab, s.tree))
		s.free_closing = vim.o.columns - fixed_columns(tab, s.tree)
	end
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
	local free_now = vim.o.columns - fixed_columns(tab)
	if s.free_closing > 0 then
		apply(scale(targets, free_now / s.free_closing))
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
