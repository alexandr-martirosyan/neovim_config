local M = {}

M.opts = {}

M.config = function(_, opts)
	local lspconfig = require "lspconfig"

	local lsp_settings = require "alexander.configs.plugins.diagnostics.lsp.lspconfig"

	local on_attach = lsp_settings.on_attach
	local on_init = lsp_settings.on_init
	local capabilities = lsp_settings.capabilities
	local handlers = lsp_settings.handlers
	local disabled_servers = lsp_settings.disabled_servers

	require("mason-lspconfig").setup()

	require("mason-lspconfig").setup_handlers {
		-- The first entry (without a key) will be the default handler
		-- and will be called for each installed server that doesn't have
		-- a dedicated handler.
		function(server_name) -- default handler (optional)
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
			server_name = vim.split(server_name, "@")[1]

			local require_ok, conf_opts = pcall(require, "alexander.configs.plugins.diagnostics.lsp.lspconfig." .. server_name)
			if require_ok then
				options = vim.tbl_deep_extend("force", conf_opts, options)
			end

			lspconfig[server_name].setup(options)
			print(server_name .. " is installed")
		end
	}
end

return M
