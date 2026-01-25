local todocomments = require "alexander.plugins.todo-comments.todo-comments"

local M = {
	{
		"folke/todo-comments.nvim",
		event = "BufEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = todocomments.opts
	}
}

return M
