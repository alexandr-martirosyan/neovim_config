local M = {}

-- If you want icons for diagnostic errors, you'll need to define them somewhere:
vim.fn.sign_define("DiagnosticSignError",
	{ text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",
	{ text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",
	{ text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",
	{ text = "󰌵", texthl = "DiagnosticSignHint" })

M.opts = {
	window = {
		mappings = {
			["w"] = "noop",
			["l"] = "noop",
			["W"] = "open_with_window_picker",
			["L"] = "focus_preview",
		}
	}
}

-- TODO: need to be configured after, it is just initial config
return M
