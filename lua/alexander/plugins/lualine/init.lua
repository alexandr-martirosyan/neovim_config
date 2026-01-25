local lualine = require 'alexander.plugins.lualine.lualine'

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
