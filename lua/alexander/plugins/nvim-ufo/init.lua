local nvim_ufo = require("alexander.plugins.nvim-ufo.nvim-ufo")

local M = {
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		event = "BufEnter",
		keys = nvim_ufo.keys,
		config = nvim_ufo.config,
	},
}

return M
