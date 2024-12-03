return {
	name = "circom-lsp",
	cmd = { "circom-lsp" },
	filetypes = { "circom" },
	root_dir = require("lspconfig/util").root_pattern({ "package.json" }) or vim.api.nvim_buf_get_name(0)
	-- root_dir = function()
	-- 	return require("lspconfig/util").root_pattern({ "package.json" }) or vim.api.nvim_buf_get_name(0)
	-- end,
}
