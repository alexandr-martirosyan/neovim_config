local todocomments = require "alexander.configs.plugins.todo-comments"

local M = {
	{
		"folke/todo-comments.nvim",
		event = "BufEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = todocomments.opts
	}
}

return M
