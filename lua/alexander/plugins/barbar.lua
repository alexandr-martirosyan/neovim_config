local barbar_config = require "alexander.configs.plugins.barbar"

local M = {
	{
		'romgrk/barbar.nvim',
		dependencies = {
			'lewis6991/gitsigns.nvim',  -- OPTIONAL: for git status
			'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
		},
		lazy = false,
		version = '^1.0.0',           -- optional: only update when a new 1.x version is released
		init = barbar_config.init,
		opts = barbar_config.opts
	},
}

return M
