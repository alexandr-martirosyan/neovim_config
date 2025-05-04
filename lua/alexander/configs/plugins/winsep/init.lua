local M = {}

M.opts = {
	-- This plugin will not be activated for filetype in the following table.
	no_exec_files = { "neo-tree", "NeoTree", "Lazy", "packer", "TelescopePrompt", "mason", "CompetiTest", "NvimTree" },
	-- Symbols for separator lines, the order: horizontal, vertical, top left, top right, bottom left, bottom right.
	symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
	-- #70: https://github.com/nvim-zh/colorful-winsep.nvim/discussions/70
	only_line_seq = true,
	-- Smooth moving switch
	smooth = false,
	exponential_smoothing = false,
}

return M
