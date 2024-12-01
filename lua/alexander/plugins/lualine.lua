local lualine = require 'alexander.configs.plugins.lualine'

local M = {
	{
		'nvim-lualine/lualine.nvim',
		lazy = false,
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = lualine.opts,
		-- config = lualine.config,
	}
}

return M
