local lazygit = require("alexander.plugins.lazytools.lazygit")
-- local lazydocker = require "alexander.plugins.lazytools.lazydocker"

local M = {
	-- nvim v0.8.0
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
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
		keys = lazygit.keys,
		config = lazygit.config,
	},
	-- {
	-- 	"crnvl96/lazydocker.nvim",
	-- 	event = "VeryLazy",
	-- 	opts = lazydocker.opts,
	-- 	dependencies = {
	-- 		"MunifTanjim/nui.nvim",
	-- 	},
	-- }
}

return M
