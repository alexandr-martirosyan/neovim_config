-- local neo_tree_cfg = require("alexander.configs.plugins.neo-tree")
--
-- local M = {
-- 	{
-- 		"nvim-neo-tree/neo-tree.nvim",
-- 		branch = "v3.x",
-- 		event = "VeryLazy",
-- 		dependencies = {
-- 			"nvim-lua/plenary.nvim",
-- 			"nvim-tree/nvim-web-devicons",
-- 			"MunifTanjim/nui.nvim",
-- 			"3rd/image.nvim",
-- 		},
-- 		-- Simply reference the functions from your config module
-- 		opts = neo_tree_cfg.opts,
-- 		config = neo_tree_cfg.config,
-- 	},
-- }
--
-- return M

local neo_tree = require("alexander.configs.plugins.neo-tree")

local M = {
	{
		"nvim-neo-tree/neo-tree.nvim",
    event = "VeryLazy",
		branch = "v3.x",
		cmd = { "Neotree" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			"3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		opts = neo_tree.opts,
	},
}

return M
