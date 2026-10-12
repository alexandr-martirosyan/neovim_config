local telescope = require("alexander.plugins.telescope.telescope")

local M = {
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	{
		"nvim-telescope/telescope.nvim",
		version = false, -- docs say "*", but the last release is from Feb 2026 while master keeps getting fixes (incl. Neovim 0.12)
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- TODO: configure nvim-dap (adapters + keymaps); then add a Telescope dap extension if wanted
			"mfussenegger/nvim-dap",
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-frecency.nvim",
			"folke/trouble.nvim",
		},
		keys = telescope.keys,
		opts = telescope.opts,
		config = telescope.config,
	},
	{
		"nvim-telescope/telescope-frecency.nvim",
		-- install the latest stable version
		version = false, -- docs say "*", but the last release is from Sep 2025 while master has the Neovim 0.12 fixes
	},
}

return M
