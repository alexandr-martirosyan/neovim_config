local M = {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate",
		opts = require("alexander.configs.plugins.nvim-treesitter").opts,
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	}
}

return M
