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
	-- Ensure Neovim treats .circom files as the "circom" filetype
	vim.cmd("autocmd BufRead,BufNewFile *.circom set filetype=circom")
	require("nvim-treesitter.configs").setup(opts)

	require("alexander.configs.plugins.nvim-treesitter.circom").config_circom()
end

return M
