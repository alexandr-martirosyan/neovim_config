local M = {}

M.opts = {
	ensure_installed = "all",

	highlight = {
		enable = true,
		use_languagetree = true,
	},

	indent = { enable = true },
}

M.config = function(_, opts)
	require("nvim-treesitter.configs").setup(opts)
end

return M
