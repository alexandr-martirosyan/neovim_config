local harpoon = require("alexander.plugins.harpoon.harpoon")

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
