local nvim_lint = require("alexander.plugins.diagnostics.nvim-lint")
local conform = require("alexander.plugins.diagnostics.conform")
local mason = require("alexander.plugins.diagnostics.lsp.mason")
local lspconfig = require("alexander.plugins.diagnostics.lsp.lspconfig")
local mason_lspconfig = require("alexander.plugins.diagnostics.lsp.mason-lspconfig")

local M = {
	-- lint
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		keys = nvim_lint.keys,
		opts = nvim_lint.opts,
		config = nvim_lint.config,
	},
	-- conform
	{
		"stevearc/conform.nvim",
		cmd = { "ConformInfo" },
		keys = conform.keys,
		opts = conform.opts,
		config = conform.config,
	},
	-- lsp stuff
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonReinstallAll", "MasonUpdate" },
		opts = mason.opts,
		config = mason.config,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- Completion capabilities come from blink.cmp (configured in its own folder).
			"saghen/blink.cmp",
			{ "hrsh7th/cmp-nvim-lsp", cond = false }, -- nvim-cmp's capabilities source, replaced by blink
		},
		config = lspconfig.config,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"neovim/nvim-lspconfig",
			"mason-org/mason.nvim",
		},
		config = mason_lspconfig.config,
	},
}

return M
