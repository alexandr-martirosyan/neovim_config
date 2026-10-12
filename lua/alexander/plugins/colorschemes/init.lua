local M = {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		opts = {
			-- Catppuccin removed `default_integrations` and now auto-enables an integration for every
			-- detected plugin. Its barbar colours break Barbar's "slanted" preset, and others (e.g. a red
			-- colorful-winsep) were never chosen. Keep the integration set from before that change.
			auto_integrations = false,
			-- TEMPORARY (testing): darker background for unfocused windows, instead of colorful-winsep.
			-- percentage = how much darker (0.15 is Catppuccin's default).
			dim_inactive = { enabled = true, shade = "dark", percentage = 0.10 },
			integrations = {
				alpha = true,
				blink_cmp = { enabled = true, style = "bordered" },
				blink_indent = true,
				fzf = true,
				cmp = true,
				dap = true,
				dap_ui = true,
				dashboard = true,
				diffview = false,
				flash = true,
				gitsigns = true,
				markdown = true,
				neogit = true,
				neotree = true,
				nvimtree = true,
				ufo = true,
				rainbow_delimiters = true,
				render_markdown = true,
				telescope = { enabled = true },
				treesitter_context = true,
				illuminate = { enabled = true, lsp = false },
				indent_blankline = { enabled = true, scope_color = "", colored_indent_levels = false },
				navic = { enabled = false, custom_bg = "NONE" },
				dropbar = { enabled = true, color_mode = false },
				colorful_winsep = { enabled = false, color = "red" },
				mini = { enabled = true, indentscope_color = "overlay2" },
				lir = { enabled = false, git_status = false },
				snacks = { enabled = false },
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			-- load the colorscheme here
			vim.cmd.colorscheme("catppuccin-macchiato")
			-- vim.cmd.colorscheme "catppuccin-latte"
		end,
	},
}

return M
