local nvim_window_picker = require("alexander.plugins.nvim-window-picker.nvim-window-picker")

local M = {
	{
		"s1n7ax/nvim-window-picker",
		name = "window-picker",
		event = "VeryLazy",
		version = "2.*",
		opts = nvim_window_picker.opts,
	},
}

return M
