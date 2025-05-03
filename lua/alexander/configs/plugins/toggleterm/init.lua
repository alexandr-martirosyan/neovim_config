local M = {}

M.opts = {
	-- size can be a number or function which is passed the current terminal
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return math.floor(vim.o.columns * 0.4)
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
			if term.direction == "horizontal" then
				return math.floor(vim.o.columns * 0.6) 
			elseif term.direction == "vertical" then
				return math.floor(vim.o.columns * 0.8) 
			end
		end,

		height = math.floor(vim.o.lines * 0.6),
		-- row = <value>,
		-- col = <value>,
		-- winblend = 3,
		-- zindex = <value>,
	},
}

return M
