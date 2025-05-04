local winsep = require("alexander.configs.plugins.winsep")

local M = {
	{
		"nvim-zh/colorful-winsep.nvim",
		event = { "WinLeave" },
		opts = winsep.opts
	},
}

return M

-- return {}
