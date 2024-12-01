local harpoon = require("alexander.configs.plugins.harpoon")

local M = {
	{
		"ThePrimeagen/harpoon",
		event = "BufEnter",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = harpoon.config,
	},
}

return M
