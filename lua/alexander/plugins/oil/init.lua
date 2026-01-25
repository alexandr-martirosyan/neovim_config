local oil = require("alexander.plugins.oil.oil")

local M = {
	{
		"stevearc/oil.nvim",
		cmd = { "Oil" },
		dependencies = {
			{ "echasnovski/mini.icons" },
			{ "nvim-tree/nvim-web-devicons" },
		},
		opts = oil.opts,
	},
}

return M
