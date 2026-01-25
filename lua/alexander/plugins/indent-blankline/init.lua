local ibl = require("alexander.plugins.indent-blankline.indent-blankline")

local M = {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = "BufEnter",
		opts = ibl.opts,
	},
}

return M
