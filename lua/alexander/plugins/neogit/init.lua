local neogit = require("alexander.plugins.neogit.neogit")

local M = {
	{
		"NeogitOrg/neogit",
		cmd = "Neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
			-- TODO: configure fzf-lua (own spec/keys); Neogit keeps using Telescope (integrations.fzf_lua = false)
			"ibhagwan/fzf-lua", -- optional
		},
		keys = neogit.keys,
		opts = neogit.opts,
	},
}

return M
