local nvim_ufo = require("alexander.configs.plugins.nvim-ufo")

local M = {
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
		},
		event = "BufEnter",
		config = nvim_ufo.config,
	},
}

return M
