local M = {}

local saved_proportions = {}

local function get_non_neotree_windows()
	return vim.tbl_filter(function(win)
		local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
		return not bufname:match("neo%-tree")
	end, vim.api.nvim_list_wins())
end

function M.save_window_proportions()
	saved_proportions = {}
	local total = vim.o.columns
	for _, win in ipairs(get_non_neotree_windows()) do
		local width = vim.api.nvim_win_get_width(win)
		saved_proportions[win] = width / total
	end
end

function M.redistribute_windows()
	local total = vim.o.columns
	local wins = get_non_neotree_windows()

	-- Sum proportions
	local prop_sum = 0
	for _, win in ipairs(wins) do
		local prop = saved_proportions[win] or (1 / #wins)
		prop_sum = prop_sum + prop
	end

	for _, win in ipairs(wins) do
		local prop = saved_proportions[win] or (1 / #wins)
		local norm = prop / prop_sum
		local width = math.floor(total * norm)
		pcall(vim.api.nvim_win_set_width, win, width)
	end
end

function M.toggle_neotree_preserving_layout()
	local is_open = vim.fn.bufwinnr("Neo-tree") ~= -1

	if not is_open then
		M.save_window_proportions()
		vim.cmd("Neotree toggle")
		vim.defer_fn(function()
			M.redistribute_windows()
		end, 100)
	else
		vim.cmd("Neotree toggle")
		vim.defer_fn(function()
			M.redistribute_windows()
		end, 100)
	end
end

return M
