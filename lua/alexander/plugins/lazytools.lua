local lazygit = require "alexander.configs.plugins.lazytools.lazygit"
local lazydocker = require "alexander.configs.plugins.lazytools.lazydocker"

local M = {
	-- nvim v0.8.0
	{
		"kdheepak/lazygit.nvim",
		lazy = false,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = lazygit.config
	},
	{
		"crnvl96/lazydocker.nvim",
		event = "VeryLazy",
		opts = lazydocker.opts,
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	}
}

return M
