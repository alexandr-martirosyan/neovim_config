local M = {}

M.opts = {}
M.build = function()
	require("dbee").install()
end
M.config = function(_, opts)
	-- require("dbee").setup(opts)
	require("dbee").setup()
end
M.cmd = { "Dbee" }

M.keys = {
	{ "<leader>db", "<cmd>Dbee<cr>", mode = "n", desc = "Open Dbee window" },
}

return M
