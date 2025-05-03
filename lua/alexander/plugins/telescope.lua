local telescope = require("alexander.configs.plugins.telescope")

local M = {
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap",
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-telescope/telescope-media-files.nvim",
		},
		opts = telescope.opts,
		config = telescope.config,
	},
	{
		"nvim-telescope/telescope-frecency.nvim",
		-- install the latest stable version
		version = "*",
	},
}

return M
