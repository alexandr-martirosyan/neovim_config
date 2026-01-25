local barbar = require("alexander.plugins.barbar.barbar")

local M = {
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- Optional: for git status in tabs
			"echasnovski/mini.icons", -- Use your new icon provider
		},
		lazy = false,
		version = "^1.0.0", -- optional: only update when a new 1.x version is released
		init = barbar.init,
		opts = barbar.opts,
		enabled = true,
	},
}

return M
