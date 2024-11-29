local whichkey = require "alexander.configs.plugins.which-key"

local M = {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = whichkey.opts,
	}
}

return M
