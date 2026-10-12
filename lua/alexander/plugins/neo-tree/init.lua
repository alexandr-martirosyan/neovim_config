local neo_tree = require("alexander.plugins.neo-tree.neo-tree")

local M = {
	{
		"nvim-neo-tree/neo-tree.nvim",
		event = "VeryLazy",
		branch = "v3.x", -- docs (and your original setting)
		cmd = { "Neotree" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		init = neo_tree.init,
		keys = neo_tree.keys,
		opts = neo_tree.opts,
	},
}

return M
