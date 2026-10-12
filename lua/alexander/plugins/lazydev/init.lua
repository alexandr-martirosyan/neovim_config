local lazydev = require("alexander.plugins.lazydev.lazydev")

local M = {
	{
		"folke/lazydev.nvim",
		version = false, -- follow main: v1.10.0 (Oct 2025) breaks go-to-definition for modules in your own lua/ folder; fixed on main
		ft = "lua", -- only load on lua files
		opts = lazydev.opts,
	},
}

return M
