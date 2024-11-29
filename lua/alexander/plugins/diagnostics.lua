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
		"williamboman/mason-lspconfig.nvim",
		event = "BufEnter",
	},
	{
		"neovim/nvim-lspconfig",
		event = "BufEnter",
		-- config = function()
		-- 	require("nvchad.configs.lspconfig").defaults()
		-- end,
	},
}

return M
