local barbar = require("alexander.plugins.barbar.barbar")

local M = {
	-- NOTE: commented to test my fork version
	-- {
	-- 	"romgrk/barbar.nvim",
	-- 	dependencies = {
	-- 		"lewis6991/gitsigns.nvim", -- Optional: for git status in tabs
	-- 		"echasnovski/mini.icons", -- Use your new icon provider
	-- 	},
	-- 	lazy = false,
	-- 	version = "^1.0.0", -- optional: only update when a new 1.x version is released
	-- 	init = barbar.init,
	-- 	opts = barbar.opts,
	-- 	enabled = true,
	-- },

	{
		dir = "~/projects/lua/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- Optional: for git status in tabs
			"echasnovski/mini.icons", -- Use your new icon provider
		},
		lazy = false,
		-- version = "^1.0.0", -- optional: only update when a new 1.x version is released
		init = barbar.init,
		opts = barbar.opts,
		enabled = true,
	},
}

return M
