local kulala = require("alexander.plugins.kulala.kulala")

local M = {
	{
		"dont-be-evil-company/kulala.nvim",
		event = "SessionLoadPost",
		keys = kulala.keys,
		ft = kulala.ft,
		opts = kulala.opts,
	},
}

return M
