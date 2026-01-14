local M = {}

M.opts = {
	-- size can be a number or function which is passed the current terminal
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return math.floor(vim.o.columns * 0.41)
		end
	end,
	hide_numbers = false, -- hide the number column in toggleterm buffers
	-- This field is only relevant if direction is set to 'float'
	float_opts = {
		-- The border key is *almost* the same as 'nvim_open_win'
		-- see :h nvim_open_win for details on borders however
		-- the 'curved' border is a custom border type
		-- not natively supported but implemented in this plugin.
		border = "curved",
		-- like `size`, width, height, row, and col can be a number or function which is passed the current terminal
		-- width = math.floor(vim.o.columns * 0.6), -- 60% of the window width
		width = function(term)
			local ui = vim.api.nvim_list_uis()[1]
			local is_vertical = ui.width < (ui.height * 1.8)
			-- local is_vertical = vim.o.columns > vim.o.lines
			if is_vertical then
				return math.floor(vim.o.columns * 0.81)
			else
				return math.floor(vim.o.columns * 0.61)
			end
		end,

		height = math.floor(vim.o.lines * 0.61),
		-- row = <value>,
		-- col = <value>,
		-- winblend = 3,
		-- zindex = <value>,
	},
}

M.toggle_exclusive = function(target_id)
	local ok, toggleterm = pcall(require, "toggleterm")
	if not ok then
		return
	end

	local terminal = require("toggleterm.terminal")

	-- 1. Get ALL currently created terminals dynamically
	-- This returns a list of terminal objects that exist in memory
	local terminals = terminal.get_all()

	-- 2. Iterate through them and hide the ones we don't want
	for _, term in pairs(terminals) do
		-- If this terminal is NOT our target, and it is currently OPEN
		if term.id ~= target_id and term:is_open() then
			term:close() -- Hide it
		end
	end

	-- 3. Open the target terminal
	toggleterm.toggle(target_id, 0, nil, "tab")
end

return M
