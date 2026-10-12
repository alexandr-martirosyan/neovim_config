local harpoon = require("alexander.plugins.harpoon.harpoon")

local M = {
	{
		"ThePrimeagen/harpoon",
		keys = harpoon.keys,
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		config = harpoon.config,
	},
}

return M
