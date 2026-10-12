local alpha = require("alexander.plugins.startup.alpha")

local M = {
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { "nvim-mini/mini.icons", "nvim-tree/nvim-web-devicons" },
		config = alpha.config,
	},
}

return M
