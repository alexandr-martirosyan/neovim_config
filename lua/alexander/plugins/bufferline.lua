local bufferline = require "alexander.configs.plugins.bufferline"

local M = {
	{
		'akinsho/bufferline.nvim',
		version = "*",
		lazy = false,
		dependencies = 'nvim-tree/nvim-web-devicons',
		opts = bufferline.opts,
		enabled = false,
	}
}

return M
