local context = require("alexander.plugins.nvim-treesitter-context.nvim-treesitter-context")

local M = {
	{
		-- Pins the current function/class line(s) at the top of the window while scrolling
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		keys = context.keys,
		opts = context.opts,
	},
}

return M
