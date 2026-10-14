local winshift = require("alexander.plugins.winshift.winshift")

local M = {
	{
		"sindrets/winshift.nvim",
		event = "BufEnter",
		keys = winshift.keys,
		opts = winshift.opts,
		cond = false, -- was `enabled = false`; cond keeps it installed like the other disabled plugins
	},
}

return M
