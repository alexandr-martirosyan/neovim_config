return {
	name = "circom-lsp",
	cmd = { "circom-lsp" },
	filetypes = { "circom" },
	root_dir = function(bufnr, on_dir)
		on_dir(vim.fs.root(bufnr, { "package.json", ".git" }) or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
	end,
}
