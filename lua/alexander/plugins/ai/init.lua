local avante = require("alexander.plugins.ai.avante.avante")
local codecompanion = require("alexander.plugins.ai.codecompanion.codecompanion")

local M = {
	-- Avante
	{
		"yetone/avante.nvim",
		build = vim.fn.has("win32") ~= 0
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		event = "VeryLazy",
		version = false,
		opts = avante.opts,
		cmd = avante.cmd,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope.nvim",
			"hrsh7th/nvim-cmp",
			"MeanderingProgrammer/render-markdown.nvim",
			"HakonHarnes/img-clip.nvim",
		},
	},
	-- Code Companion
	{
		"olimorris/codecompanion.nvim",
		version = "^19.0.0",
		opts = codecompanion.opts,
		cmd = codecompanion.cmd,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/mcphub.nvim",
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion", "Avante" },
		opts = {
			file_types = { "markdown", "codecompanion", "Avante" },
		},
	},
	{
		"HakonHarnes/img-clip.nvim",
		opts = {
			filetypes = {
				codecompanion = {
					prompt_for_file_name = false,
					template = "[Image]($FILE_PATH)",
					use_absolute_path = true,
				},
				Avante = {
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					use_absolute_path = true,
				},
			},
		},
	},
	-- Other AI
}

return M
