local whichkey = require("alexander.plugins.which-key.which-key")

local M = {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = whichkey.opts,
	},
}

return M
