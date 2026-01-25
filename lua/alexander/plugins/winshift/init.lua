local winshift = require("alexander.plugins.winshift.winshift")

local M = {
	{
		"sindrets/winshift.nvim",
		event = "BufEnter",
		opts = winshift.opts,
		enabled = false,
	},
}

return M
