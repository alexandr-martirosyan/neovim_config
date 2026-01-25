local kulala = require("alexander.plugins.kulala.kulala")

local M = {
	{
		"mistweaverco/kulala.nvim",
		keys = kulala.keys,
		ft = kulala.ft,
		opts = kulala.opts,
	},
}

return M
