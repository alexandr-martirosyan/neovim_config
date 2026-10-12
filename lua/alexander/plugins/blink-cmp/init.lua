local blink = require("alexander.plugins.blink-cmp.blink-cmp")

local M = {
	{
		"saghen/blink.cmp",
		version = "1.*", -- docs: stay on 1.x; v2 has breaking changes (also ships prebuilt binaries)
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"onsails/lspkind.nvim",
			"saghen/blink.compat",
			-- blink-copilot (copilot folder) loads on first use of the copilot source, so Copilot
			-- still starts on InsertEnter rather than with the LSP capabilities request.
		},
		opts = blink.opts,
		opts_extend = { "sources.default" },
	},
	{
		-- Lets blink use nvim-cmp style sources (Avante registers its sources through it).
		"saghen/blink.compat",
		version = "2.*", -- docs: blink.compat 2.x for blink.cmp 1.x
		lazy = true,
		opts = {},
	},
}

return M
