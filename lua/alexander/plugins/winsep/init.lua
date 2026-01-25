local winsep = require("alexander.plugins.winsep.winsep")

local M = {
	{
		"nvim-zh/colorful-winsep.nvim",
		event = { "WinLeave" },
		opts = winsep.opts,
		-- enabled = false,
	},
}

return M
