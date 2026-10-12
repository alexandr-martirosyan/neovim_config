local M = {}

M.ensure_installed = {
	-- lua
	"stylua",
	"lua-language-server",
	-- solidity
	"solhint",
	"nomicfoundation-solidity-language-server",
	-- rust
	"rust-analyzer",
	-- python
	"pyright",
	"flake8",
	"black",
	-- deno
	"deno",
	-- formatters
	"prettier",
	"eslint-lsp",
	-- js, ts
	"typescript-language-server",
	-- kulala rest service
	"kulala-fmt",
	-- spell
	"typos-lsp",
	-- docker
	"dockerfile-language-server",
	"hadolint",
	-- zk
	"circom-lsp",
	-- toml
	"tombi",
}

-- Installing a package does not silently opt its LSP into every project.
M.servers = {
	"lua_ls",
	"solidity_ls_nomicfoundation",
	"rust_analyzer",
	"pyright",
	"denols",
	"eslint",
	"ts_ls",
	"typos_lsp",
	"dockerls",
	"tombi",
}
M.enable_circom = false -- Keep the custom server opt-in.

return M
