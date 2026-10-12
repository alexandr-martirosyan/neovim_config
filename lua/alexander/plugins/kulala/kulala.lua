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
	-- Kulala's defaults, except send keys use Visual-only ("x") instead of "v" (Visual + Select),
	-- so they don't fire while typing into a snippet placeholder.
	global_keymaps = {
		["Send request"] = {
			"<leader>Rs",
			function()
				require("kulala").run()
			end,
			mode = { "n", "x" },
		},
		["Send request <cr>"] = {
			"<CR>",
			function()
				require("kulala").run()
			end,
			mode = { "n", "x" },
			ft = { "http", "rest" },
		},
		["Send all requests"] = {
			"<leader>Ra",
			function()
				require("kulala").run_all()
			end,
			mode = { "n", "x" },
		},
	},
	global_keymaps_prefix = "<leader>R",
	kulala_keymaps_prefix = "",
}

return M
