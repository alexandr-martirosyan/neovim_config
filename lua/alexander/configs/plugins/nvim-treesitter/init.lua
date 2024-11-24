local M = {}

M.opts = {
	ensure_installed = require "alexander.package-settings.nvim-treesitter",
	highlight = {
		enable = true,
		use_languagetree = true,
	},

	indent = { enable = true },
}

return M
