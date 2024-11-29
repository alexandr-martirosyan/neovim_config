local lazydev = require "alexander.configs.plugins.lazydev"

local M = {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = lazydev.opts,
	}
}

return M
