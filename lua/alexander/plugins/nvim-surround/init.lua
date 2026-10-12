local surround = require("alexander.plugins.nvim-surround.nvim-surround")

local M = {
	{
		-- Add / change / delete surrounding quotes, brackets and tags
		"kylechui/nvim-surround",
		version = "^4.0.0", -- docs
		event = "VeryLazy",
		opts = surround.opts,
	},
}

return M
