local severity = vim.diagnostic.severity
vim.diagnostic.config({
	severity_sort = true,
	virtual_text = { prefix = "" },
	signs = {
		text = { [severity.ERROR] = "󰅙", [severity.WARN] = "", [severity.INFO] = "󰋼", [severity.HINT] = "󰌵" },
	},
	underline = true,
	float = { border = "single" },
})

-- Command to toggle inline diagnostics
vim.api.nvim_create_user_command("DiagnosticsToggleVirtualText", function()
	vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
end, {})

-- Command to toggle diagnostics
vim.api.nvim_create_user_command("DiagnosticsToggle", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, {})
