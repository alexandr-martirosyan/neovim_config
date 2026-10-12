local autopairs = require("alexander.plugins.nvim-cmp.nvim-autopairs")
local luasnip = require("alexander.plugins.nvim-cmp.LuaSnip")
local cmp = require("alexander.plugins.nvim-cmp.nvim-cmp")

local M = {
	{
		-- kind icons; used by blink.cmp (and by nvim-cmp when enabled)
		"onsails/lspkind.nvim",
	},
	{
		-- Replaced by blink.cmp (plugins/blink-cmp). Kept declared and configured, but disabled.
		"hrsh7th/nvim-cmp",
		cond = false,
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"onsails/lspkind.nvim",
			{ "zbirenbaum/copilot-cmp", cond = false },
			-- Autopairs remains a separate InsertEnter spec below, avoiding a cycle.
			{ "saadparwaiz1/cmp_luasnip", cond = false },
			{ "hrsh7th/cmp-nvim-lua", cond = false }, -- lazydev handles Neovim Lua completion
			{ "hrsh7th/cmp-nvim-lsp", cond = false },
			{ "hrsh7th/cmp-buffer", cond = false },
			{ "hrsh7th/cmp-path", cond = false },
			{ "hrsh7th/cmp-cmdline", cond = false }, -- no command-line source is configured
		},
		opts = cmp.opts,
	},
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- docs (and your original setting); LuaSnip
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
		opts = luasnip.opts,
		config = luasnip.config,
	},
	{
		-- autopairing of (){}[] etc
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		-- Only needed for the nvim-cmp confirm hook; blink.cmp adds brackets itself.
		dependencies = { { "hrsh7th/nvim-cmp", cond = false } },
		opts = autopairs.opts,
		config = autopairs.config,
	},
}

return M
