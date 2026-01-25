local treesitter = require("alexander.plugins.nvim-treesitter.nvim-treesitter")

local M = {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate",
		opts = treesitter.opts,
		config = treesitter.config,
	},
}

return M
