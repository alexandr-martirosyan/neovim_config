local mason_settings = require "alexander.configs.plugins.diagnostics.lsp.mason.settings"

local M = {}

M.opts = {
	ui = {
		icons = {
			package_pending = " ",
			package_installed = " ",
			package_uninstalled = " ",
		},
	},

	max_concurrent_installers = 10,
	ensure_installed = mason_settings.ensure_installed
}

M.config = function(_, opts)
	require("mason").setup(opts)

	vim.api.nvim_create_user_command("MasonInstallAll", function()
		if opts.ensure_installed and #opts.ensure_installed > 0 then
			vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
		end
	end, {})

	vim.g.mason_binaries_list = opts.ensure_installed
end

return M
