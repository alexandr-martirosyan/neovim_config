-- lua/alexander/plugins/bufferline/init.lua
local bufferline = require("alexander.plugins.bufferline.bufferline")

local M = {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		lazy = false, -- Load on startup for UI consistency [cite: 51]
		dependencies = {
			"echasnovski/mini.icons",
			"tiagovla/scope.nvim", -- Ensure Scope is a dependency
		},
		opts = bufferline.opts,
		enabled = false, -- Enable this!
	},
	-- Ensure Barbar is disabled in your other file
}

return M
