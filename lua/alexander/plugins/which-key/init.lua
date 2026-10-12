local whichkey = require("alexander.plugins.which-key.which-key")

local M = {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = whichkey.keys,
		opts = whichkey.opts,
	},
}

return M
