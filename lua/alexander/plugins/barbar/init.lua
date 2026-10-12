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
		"alexandr-martirosyan/barbar.nvim",
		-- Fallback for machines without the local checkout: the pushed filename_depth branch
		-- (same commit as the local checkout). The fork's master is plain upstream.
		commit = "a49658503cceab4c45ac9f37c695de0554df4162",
		dir = vim.uv.fs_stat(vim.fn.expand("~/projects/lua/barbar.nvim")) and vim.fn.expand("~/projects/lua/barbar.nvim")
			or nil,
		dependencies = {
			"lewis6991/gitsigns.nvim", -- Optional: for git status in tabs
			"nvim-mini/mini.icons", -- icon provider (mocks nvim-web-devicons)
		},
		lazy = false,
		-- version = "^1.0.0", -- optional: only update when a new 1.x version is released
		init = barbar.init,
		keys = barbar.keys,
		opts = barbar.opts,
		enabled = true,
	},
}

return M
