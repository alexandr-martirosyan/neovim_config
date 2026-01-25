local M = {}

-- If you want icons for diagnostic errors, you'll need to define them somewhere:
vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

M.opts = {
	filesystem = {
    -- This is the key setting to keep neo-tree in sync with your active buffer
    follow_current_file = {
      enabled = true,               -- This enables the "hover" behavior
      leave_dirs_open = false,      -- Optional: closes other folders when you switch files
    },
    use_libuv_file_watcher = true,  -- Optional: automatically refreshes the tree on file changes
  },
	window = {
		mappings = {
			["w"] = "noop",
			["l"] = "noop",
			["W"] = "open_with_window_picker",
			["L"] = "focus_preview",
		},
	},
}

-- TODO: need to be configured after, it is just initial config
return M
