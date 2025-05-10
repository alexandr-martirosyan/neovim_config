local mason_settings = require("alexander.configs.plugins.diagnostics.lsp.mason.settings")

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
	ensure_installed = mason_settings.ensure_installed,
}

M.config = function(_, opts)
	require("mason").setup(opts)

	local already_installed = require("mason-registry").get_installed_package_names()

	vim.api.nvim_create_user_command("MasonInstallAll", function()
		if opts.ensure_installed and #opts.ensure_installed > 0 then
			M.InstallAll(opts.ensure_installed, already_installed)
		end
	end, {})

	vim.api.nvim_create_user_command("MasonReinstallAll", function()
		if opts.ensure_installed and #opts.ensure_installed > 0 then
			vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
		end
	end, {})

	vim.g.mason_binaries_list = opts.ensure_installed
end

M.InstallAll = function(ensure_installed, already_installed)
	local all_packages_string = ""
	local already_installed_set = {}
	for _, v in ipairs(already_installed) do
		already_installed_set[v] = true
	end

	for _, pkg_name in ipairs(ensure_installed) do
		if not already_installed_set[pkg_name] then
			all_packages_string = all_packages_string .. pkg_name .. " "
		end
	end

	local command_to_run = "Mason"
	if #all_packages_string > 0 then
		command_to_run = "MasonInstall " .. all_packages_string
	end
	vim.cmd(command_to_run)
end

return M
