local M = {}

M.init = function()
	vim.g.barbar_auto_setup = false
end
M.opts = {
	icons = {
		button = "",
		-- Enables / disables diagnostic symbols
		diagnostics = {
			[vim.diagnostic.severity.ERROR] = { enabled = true },
			[vim.diagnostic.severity.WARN] = { enabled = true },
			[vim.diagnostic.severity.INFO] = { enabled = true },
			[vim.diagnostic.severity.HINT] = { enabled = true },
		},

		-- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
		preset = "powerline",
	},

	-- Set the filetypes which barbar will offset itself for
	sidebar_filetypes = {
		-- Or, specify the event which the sidebar executes when leaving:
		["neo-tree"] = { event = "BufWipeout", text = "File Explorer", align = "center" },
	},
}

return M
