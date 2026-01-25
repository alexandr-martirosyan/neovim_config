local ts_comments = require("alexander.configs.plugins.comments.ts-comments")
local comment_nvim = require("alexander.configs.plugins.comments.comment-nvim")

local M = {
	{
		"folke/ts-comments.nvim",
		opts = ts_comments.otps,
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
	},

	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		config = comment_nvim.config,
	},
}

return M
