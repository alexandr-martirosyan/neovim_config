local neogit = require("alexander.configs.plugins.neogit")

local M = {
	{
		"NeogitOrg/neogit",
		event = "BufEnter",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
			"ibhagwan/fzf-lua", -- optional
			"echasnovski/mini.pick", -- optional
		},
		opts = neogit.opts,
	},
}

return M
