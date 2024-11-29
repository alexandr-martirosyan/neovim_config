local oil = require "alexander.configs.plugins.oil"

local M = {
	{
		'stevearc/oil.nvim',
		cmd = { "Oil" },
		dependencies = {
			{ "echasnovski/mini.icons" },
			{ "nvim-tree/nvim-web-devicons" }
		},
		opts = oil.opts,
	}
}

return M
