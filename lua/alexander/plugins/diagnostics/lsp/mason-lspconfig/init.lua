local M = {}

M.config = function()
	local settings = require("alexander.plugins.diagnostics.lsp.mason.settings")
	local lsp = require("alexander.plugins.diagnostics.lsp.lspconfig")
	local enabled = {}

	for _, server in ipairs(settings.servers) do
		if not lsp.disabled_servers[server] then
			local module = "alexander.plugins.diagnostics.lsp.lspconfig." .. server
			if #vim.api.nvim_get_runtime_file("lua/" .. module:gsub("%.", "/") .. ".lua", false) > 0 then
				-- Configuration errors should be visible, not mistaken for absent overrides.
				vim.lsp.config(server, require(module))
			end
			table.insert(enabled, server)
		end
	end

	-- This bridge is the single owner of activation for installed, approved servers.
	-- It also enables newly installed servers without restarting Neovim.
	require("mason-lspconfig").setup({ ensure_installed = {}, automatic_enable = enabled })

	if settings.enable_circom and not lsp.disabled_servers["circom-lsp"] then
		vim.lsp.config("circom-lsp", require("alexander.plugins.diagnostics.lsp.lspconfig.circom-lsp"))
		vim.lsp.enable("circom-lsp")
	end
end

return M
