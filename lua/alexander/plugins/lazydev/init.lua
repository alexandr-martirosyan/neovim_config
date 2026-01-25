local lazydev = require "alexander.plugins.lazydev.lazydev"

local M = {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = lazydev.opts,
	}
}

return M
