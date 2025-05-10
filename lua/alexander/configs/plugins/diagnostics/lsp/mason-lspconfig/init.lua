local M = {}

M.opts = {}

M.config = function(_, opts)
	local lspconfig = require("lspconfig")
	local mason_lspconfig = require("mason-lspconfig")

	local lsp_settings = require("alexander.configs.plugins.diagnostics.lsp.lspconfig")

	local on_attach = lsp_settings.on_attach
	local on_init = lsp_settings.on_init
	local capabilities = lsp_settings.capabilities
	local handlers = lsp_settings.handlers
	local disabled_servers = lsp_settings.disabled_servers

	mason_lspconfig.setup({
		automatic_enable = true,
	})

	local all_servers = mason_lspconfig.get_installed_servers()

	for _, server_name in ipairs(all_servers) do
		M.setup_server(lspconfig, on_attach, on_init, capabilities, handlers, disabled_servers, server_name)
	end

	-- setup circom as it is not in repo
	M.setup_server(lspconfig, on_attach, on_init, capabilities, handlers, disabled_servers, "circom-lsp")
end

M.setup_server = function(lspconfig, on_attach, on_init, capabilities, handlers, disabled_servers, server_name)
	-- disable if lsp was disabled
	if disabled_servers[server_name] then
		print(server_name .. " is disabled")
		return
	end

	local options = {
		on_attach = on_attach,
		on_init = on_init,
		capabilities = capabilities,
		handlers = handlers,
	}
	-- local server_name = "circom-lsp"

	local require_ok, conf_opts = pcall(require, "alexander.configs.plugins.diagnostics.lsp.lspconfig." .. server_name)
	if require_ok then
		options = vim.tbl_deep_extend("force", conf_opts, options)
	end

	lspconfig[server_name].setup(options)
	print(server_name .. " is installed")
end

return M
