local copilot = require("alexander.plugins.copilot.copilot")
local copilot_cmp = require("alexander.plugins.copilot.copilot-cmp")
local blink_copilot = require("alexander.plugins.copilot.blink-copilot")

local M = {
	{
		"zbirenbaum/copilot.lua",
		cmd = { "Copilot" },
		event = { "InsertEnter" },
		opts = copilot.opts,
	},
	{
		"zbirenbaum/copilot-cmp",
		cond = false, -- replaced by blink-copilot (nvim-cmp is disabled)
		dependencies = { "zbirenbaum/copilot.lua" },
		lazy = true,
		config = copilot_cmp.config,
	},
	{
		-- Copilot source for blink.cmp
		"fang2hou/blink-copilot",
		dependencies = { "zbirenbaum/copilot.lua" },
		lazy = true,
		opts = blink_copilot.opts,
	},
}

return M
