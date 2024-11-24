local M = {
	{
		'akinsho/bufferline.nvim',
		version = "*",
		lazy = false,
		dependencies = 'nvim-tree/nvim-web-devicons',
		opts = require("alexander.configs.plugins.bufferline").opts,
		enabled = false,
	}
}

return M
