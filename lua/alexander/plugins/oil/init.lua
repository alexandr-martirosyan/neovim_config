local oil = require("alexander.plugins.oil.oil")

local M = {
	{
		"stevearc/oil.nvim",
		cmd = { "Oil" },
		dependencies = {
			{ "nvim-mini/mini.icons" },
			{ "nvim-tree/nvim-web-devicons" },
		},
		keys = oil.keys,
		opts = oil.opts,
	},
}

return M
