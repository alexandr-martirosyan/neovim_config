local M = {}

M.opts = {
	-- Keep window width proportions when the tree opens/closes (see keep-layout.lua).
	event_handlers = require("alexander.plugins.neo-tree.keep-layout").event_handlers,
	filesystem = {
		-- This is the key setting to keep neo-tree in sync with your active buffer
		follow_current_file = {
			enabled = true, -- This enables the "hover" behavior
			leave_dirs_open = false, -- Optional: closes other folders when you switch files
		},
		use_libuv_file_watcher = true, -- Optional: automatically refreshes the tree on file changes
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

-- `nvim <folder>`: load neo-tree during startup instead of on VeryLazy. Its folder takeover then runs
-- immediately. Loaded late, the takeover ran when you first opened a file from the tree and swapped
-- that window to a new empty buffer, leaving an extra "[No Name]" buffer focused.
M.init = function()
	if vim.fn.argc(-1) == 1 then
		local stat = vim.uv.fs_stat(vim.fn.argv(0))
		if stat and stat.type == "directory" then
			require("neo-tree")
		end
	end
end

-- TODO: need to be configured after, it is just initial config
M.keys = {
	{ "<C-n>", "<cmd>Neotree toggle<CR>", mode = "n", desc = "neotree toggle window" },
	{ "<leader>e", "<cmd>Neotree focus<CR>", mode = "n", desc = "neotree focus window" },
}

return M
