local noice = require "alexander.configs.plugins.noice"

local M = {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = noice.opts
	}
}

return M
