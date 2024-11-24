-- added by user
vim.diagnostic.config { underline = true, virtual_text = false }

-- Command to toggle inline diagnostics
vim.api.nvim_create_user_command("DiagnosticsToggleVirtualText", function()
	vim.diagnostic.config { virtual_text = not vim.diagnostic.config().virtual_text }
end, {})

-- Command to toggle diagnostics
vim.api.nvim_create_user_command("DiagnosticsToggle", function()
	local current_value = vim.diagnostic.is_disabled()
	if current_value then
		vim.diagnostic.enable()
	else
		vim.diagnostic.disable()
	end
end, {})
