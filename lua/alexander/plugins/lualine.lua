local M = {
	{
		'nvim-lualine/lualine.nvim',
		lazy = false,
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = require('alexander.configs.plugins.lualine').opts
	}
}

return M
