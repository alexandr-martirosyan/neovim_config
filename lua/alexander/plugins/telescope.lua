local telescope = require "alexander.configs.plugins.telescope"

local M = {
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make'
	},
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		cmd = "Telescope",
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-fzf-native.nvim',
			'mfussenegger/nvim-dap'
		},
		opts = telescope.opts,
		config = telescope.config
	}
}

return M
