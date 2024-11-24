local autopairs = require("alexander.configs.plugins.nvim-cmp.nvim-autopairs")
local luasnip = require("alexander.configs.plugins.nvim-cmp.LuaSnip")
local cmp = require("alexander.configs.plugins.nvim-cmp.nvim-cmp")

local M = {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"windwp/nvim-autopairs",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
		},
		opts = cmp.opts
	},
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
		opts = luasnip.opts,
		config = luasnip.config,
	},
	{
		-- autopairing of (){}[] etc
		"windwp/nvim-autopairs",
		dependencies = { "hrsh7th/nvim-cmp" },
		opts = autopairs.opts,
		config = autopairs.config
	},
}

return M
