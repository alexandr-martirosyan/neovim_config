local treesitter = require("alexander.plugins.nvim-treesitter.nvim-treesitter")

local M = {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- current upstream does not support lazy loading
		build = treesitter.build,
		opts = treesitter.opts,
		config = treesitter.config,
	},
}

return M
