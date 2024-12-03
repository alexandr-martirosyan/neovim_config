local treesitter = require("alexander.configs.plugins.nvim-treesitter")

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
