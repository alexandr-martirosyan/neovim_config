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
	-- deno
	"deno",
	-- formatters
	"prettier",
	"eslint-lsp",
	-- js, ts
	"typescript-language-server",
	-- spell
	"codespell",
	"typos",
	-- docker
	"dockerfile-language-server",
	"hadolint",
  -- zk
  "circom-lsp"
}

return M
