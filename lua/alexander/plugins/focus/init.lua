local focus = require("alexander.plugins.focus.focus")

local M = {
	{
		"nvim-focus/focus.nvim",
		cmd = { "FocusEnable", "FocusToggle" },
		event = "WinEnter",
		opts = focus.opts,
	},
}

return M
