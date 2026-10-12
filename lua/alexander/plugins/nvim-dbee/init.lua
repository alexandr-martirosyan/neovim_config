local dbee = require("alexander.plugins.nvim-dbee.nvim-dbee")

local M = {
	{
		"kndndrj/nvim-dbee",
		cond = false, -- replaced by vim-dadbod-ui (better maintained); kept installed and configured
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		-- lazy = false,
		cmd = dbee.cmd,
		keys = dbee.keys,
		opts = dbee.opts,
		build = dbee.build,
		config = dbee.config,
	},
}

return M
