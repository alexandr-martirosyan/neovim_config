local winsep = require("alexander.plugins.winsep.winsep")

local M = {
	{
		"nvim-zh/colorful-winsep.nvim",
		branch = "main",
		event = { "WinLeave" },
		opts = winsep.opts,
		-- enabled = false,
		cond = false, -- TEMPORARY: testing Catppuccin dim_inactive instead (colorschemes/init.lua)
	},
}

return M
