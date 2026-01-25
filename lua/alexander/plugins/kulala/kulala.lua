local M = {}

M.keys = {
	{ "<leader>Rs", desc = "Send request" },
	{ "<leader>Ra", desc = "Send all requests" },
	{ "<leader>Rb", desc = "Open scratchpad" },
}

M.ft = {
	"http",
	"rest",
}

M.opts = {
	global_keymaps = true,
	global_keymaps_prefix = "<leader>R",
	kulala_keymaps_prefix = "",
}

return M
