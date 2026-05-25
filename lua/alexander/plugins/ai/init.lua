local codecompanion = require("alexander.plugins.ai.codecompanion.codecompanion")

local M = {
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
		ft = { "markdown", "codecompanion" },
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
			},
		},
	},
	-- Other AI
}

return M
