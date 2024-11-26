local conform = require "alexander.configs.plugins.conform"

local M = {
	{
		'stevearc/conform.nvim',
		opts = conform.opts,
		config = conform.config
	}
}

return M
