local smart_splits = require("alexander.plugins.smart-splits.smart-splits")

local M = {
	{
		-- One set of keys for Neovim splits and tmux panes: Ctrl+h/j/k/l moves, Ctrl+Shift+h/j/k/l resizes.
		-- Outside tmux it works on Neovim windows only. The tmux side lives in ~/.tmux.conf.
		"smart-splits-nvim/smart-splits.nvim",
		version = "^3.0.0", -- docs
		-- docs: never lazy-load with the tmux backend; tmux only learns that a pane runs Neovim when the
		-- plugin loads, and until then it keeps Ctrl+h/j/k/l for itself
		lazy = false,
		dependencies = {
			{ "smart-splits-nvim/backend-tmux", main = "smart-splits-backend-tmux" },
		},
		keys = smart_splits.keys,
		opts = smart_splits.opts,
	},
}

return M
