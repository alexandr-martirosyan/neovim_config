local M = {}

-- If you want icons for diagnostic errors, you'll need to define them somewhere:
vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })
M.opts = function(_, _)
	vim.g.neo_tree_remove_legacy_commands = 1
	-- local filesystem = nil
	-- if vim.fn.argc(-1) == 1 then
	-- 	local stat = vim.uv.fs_stat(tostring(vim.fn.argv(0)))
	-- 	if stat and stat.type == "directory" then
	-- 		filesystem = {
	-- 			hijack_netrw_behavior = "open_current",
	-- 		}
	-- 	end
	-- end
	return {
		window = {
			mappings = {
				["w"] = "noop",
				["l"] = "noop",
				["W"] = "open_with_window_picker",
				["L"] = "focus_preview",
			},
		},
		hijack_netrw_behavior = "disabled",
		-- filesystem = filesystem,
	}
end

-- M.opts = {
-- 	window = {
-- 		mappings = {
-- 			["w"] = "noop",
-- 			["l"] = "noop",
-- 			["W"] = "open_with_window_picker",
-- 			["L"] = "focus_preview",
-- 		},
-- 	},
-- }

-- TODO: need to be configured after, it is just initial config
return M
