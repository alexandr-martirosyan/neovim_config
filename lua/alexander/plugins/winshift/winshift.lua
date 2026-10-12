local M = {}

M.opts = {}

M.keys = {
	{ "<C-W><C-M>", "<Cmd>WinShift<CR>", mode = "n", desc = "Activate WinShift" },
	{ "<C-W>m", "<Cmd>WinShift<CR>", mode = "n", desc = "Activate WinShift" },
	{ "<C-W>X", "<Cmd>WinShift swap<CR>", mode = "n", desc = "Activate WinShift SWAP" },
}

return M
