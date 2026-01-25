local dbee = require("alexander.configs.plugins.nvim-dbee")

local M = {
	{
		"kndndrj/nvim-dbee",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
    -- lazy = false,
--		cmd = dbee.cmd,
		opts = dbee.opts,
		build = dbee.build,
		config = dbee.config,
	},
}

return M
