local alpha = require "alexander.configs.plugins.startup.alpha"

local M = {
	{
		'goolord/alpha-nvim',
		event = 'VimEnter',
		dependencies = { 'echasnovski/mini.icons' },
		config = alpha.config,
	}
}

return M
