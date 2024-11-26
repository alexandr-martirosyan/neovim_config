local nvim_lint = require "alexander.configs.plugins.nvim-lint"

local M = {
	{
		"mfussenegger/nvim-lint",
		event = "BufEnter",
		opts = nvim_lint.opts,
		config = nvim_lint.config,
	}
}

return M
