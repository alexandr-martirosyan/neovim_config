local M = {}

M.opts = {}

M.keys = {
	{
		"<leader>ld",
		function()
			require("lazydocker").toggle()
		end,
		mode = "n",
		desc = "LazyDocker Toggle",
	},
}

return M
