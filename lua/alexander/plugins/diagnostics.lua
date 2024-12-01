local nvim_lint = require "alexander.configs.plugins.diagnostics.nvim-lint"
local conform = require "alexander.configs.plugins.diagnostics.conform"
local mason = require "alexander.configs.plugins.diagnostics.lsp.mason"
local lspconfig = require "alexander.configs.plugins.diagnostics.lsp.lspconfig"
local mason_lspconfig = require "alexander.configs.plugins.diagnostics.lsp.mason-lspconfig"

local M = {
	-- lint
	{
		"mfussenegger/nvim-lint",
		event = "BufEnter",
		opts = nvim_lint.opts,
		config = nvim_lint.config,
	},
	-- conform
	{
		'stevearc/conform.nvim',
		opts = conform.opts,
		config = conform.config
	},
	-- lsp stuff
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
		opts = mason.opts,
		config = mason.config,
	},
	{
		"neovim/nvim-lspconfig",
		event = "BufEnter",
		dependencies = {
			'hrsh7th/nvim-cmp',
			'hrsh7th/cmp-nvim-lsp'
		},
		config = lspconfig.config,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		event = "BufEnter",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
		config = mason_lspconfig.config
	},
}

return M
