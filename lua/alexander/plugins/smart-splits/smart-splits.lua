local M = {}

M.opts = {
	mux = {
		backend = "smart-splits-backend-tmux",
		-- outside tmux, quietly use plain Neovim window movement (no warning on every start)
		warn_if_unusable = false,
	},
	-- 1 cell per press, like the previous :resize ±1 mappings (tmux's resize-pane uses the same step)
	resize = { amount = 1 },
	-- move.at_edge: default "wrap" (from the last pane, continue on the far side), like tmux's own panes
}

local function call(fn)
	return function()
		require("smart-splits")[fn]()
	end
end

-- Replaces the window keys in configs/mappings.lua (kept there, commented out).
M.keys = {
	-- move between Neovim splits; at the edge, continue into the neighbouring tmux pane
	{ "<C-h>", call("move_cursor_left"), mode = { "n", "x" }, desc = "Move to left split / tmux pane" },
	{ "<C-j>", call("move_cursor_down"), mode = { "n", "x" }, desc = "Move to lower split / tmux pane" },
	{ "<C-k>", call("move_cursor_up"), mode = { "n", "x" }, desc = "Move to upper split / tmux pane" },
	{ "<C-l>", call("move_cursor_right"), mode = { "n", "x" }, desc = "Move to right split / tmux pane" },
	-- resize: moves the border in that direction (works across Neovim and tmux); a count multiplies it
	{ "<C-S-h>", call("resize_left"), mode = "n", desc = "Resize split / tmux pane left" },
	{ "<C-S-j>", call("resize_down"), mode = "n", desc = "Resize split / tmux pane down" },
	{ "<C-S-k>", call("resize_up"), mode = "n", desc = "Resize split / tmux pane up" },
	{ "<C-S-l>", call("resize_right"), mode = "n", desc = "Resize split / tmux pane right" },
}

return M
