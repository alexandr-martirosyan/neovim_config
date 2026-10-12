local textobjects = require("alexander.plugins.nvim-treesitter-textobjects.nvim-treesitter-textobjects")

local M = {
	{
		-- Select / move by functions, classes, arguments and loops (af, if, aa, ]f, …)
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main", -- docs: the main branch matches nvim-treesitter's main branch
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		keys = textobjects.keys,
		opts = textobjects.opts,
	},
}

return M
