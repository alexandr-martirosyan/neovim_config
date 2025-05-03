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
	"codespell",
	"typos",
	-- docker
	"dockerfile-language-server",
	"hadolint",
	-- zk
	"circom-lsp",
}

return M
