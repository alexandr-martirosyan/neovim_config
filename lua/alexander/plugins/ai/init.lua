local avante = require("alexander.plugins.ai.avante.avante")
local codecompanion = require("alexander.plugins.ai.codecompanion.codecompanion")

local M = {
	-- Avante
	{
		"avante-corp/avante.nvim",
		build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		-- AI setup and native libraries load when a command/key is used.
		version = false,
		init = avante.init,
		keys = avante.keys,
		opts = avante.opts,
		cmd = avante.cmd,
		dependencies = {
			{ "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope.nvim",
			{ "hrsh7th/nvim-cmp", cond = false }, -- replaced by blink.cmp
			-- Avante registers its @/#// sources with `require("cmp")`; blink.compat provides that API.
			"saghen/blink.cmp",
			"saghen/blink.compat",
			"MeanderingProgrammer/render-markdown.nvim",
			"HakonHarnes/img-clip.nvim",
		},
	},
	-- Code Companion
	{
		"olimorris/codecompanion.nvim",
		version = "^19.0.0", -- your original setting
		keys = codecompanion.keys,
		opts = codecompanion.opts,
		cmd = codecompanion.cmd,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- TODO: configure mcphub: install the hub (build = "npm install -g mcp-hub@latest"),
			-- call require("mcphub").setup(), and add its CodeCompanion extension
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
