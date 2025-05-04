local focus = require("alexander.configs.plugins.focus")

local M = {
	{
		"nvim-focus/focus.nvim",
		event = "WinEnter",
		opts = focus.opts,
	},
}

return M
