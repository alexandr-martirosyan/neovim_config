local settings = require("alexander.plugins.diagnostics.lsp.mason.settings")
local M = {}

M.opts = {
	ui = {
		icons = { package_pending = " ", package_installed = " ", package_uninstalled = " " },
	},
	max_concurrent_installers = 10,
}

M.InstallAll = function()
	local installed = {}
	for _, name in ipairs(require("mason-registry").get_installed_package_names()) do
		installed[name] = true
	end
	local missing = vim.tbl_filter(function(name)
		return not installed[name]
	end, settings.ensure_installed)
	if #missing > 0 then
		vim.cmd("MasonInstall " .. table.concat(missing, " "))
	else
		vim.cmd("Mason")
	end
end

M.config = function(_, opts)
	require("mason").setup(opts)
	vim.api.nvim_create_user_command("MasonInstallAll", M.InstallAll, {})
	vim.api.nvim_create_user_command("MasonReinstallAll", function()
		vim.cmd("MasonInstall --force " .. table.concat(settings.ensure_installed, " "))
	end, {})
	vim.g.mason_binaries_list = settings.ensure_installed
end

return M
