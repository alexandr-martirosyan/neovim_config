local ibl = require "alexander.configs.plugins.indent-blankline"

local M = {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
    event = "BufEnter",
		opts = ibl.opts,
	}
}

return M
