local M = {}
-- local evli_lualine = require "alexander.configs.plugins.lualine.evli_lualine"
-- M.opts = evli_lualine.config;

M.opts = function(_, opts)
	local trouble = require("trouble")
	local symbols = trouble.statusline({
		mode = "lsp_document_symbols",
		groups = {},
		title = false,
		filter = { range = true },
		format = "{kind_icon}{symbol.name:Normal}",
		hl_group = "lualine_c_normal",
	})

	return {
		options = {
			theme = "auto",
			disabled_filetypes = {
				winbar = {
					"oil",
					"neo-tree",
					"NvimTree",
					"startify",
					"dashboard",
					"kulala_ui",
					"kulala",
				},
			},
		},

		winbar = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {
				{
					"filename",
					path = 4,
					shorting_target = 30,
				},
				"filetype",
			},
			lualine_z = {
				function()
					return " "
				end,
			},
		},

		inactive_winbar = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {
				{
					"filename",
					path = 4,
					shorting_target = 30,
				},
				"filetype",
			},
			lualine_z = {
				function()
					return " "
				end,
			},
		},

		sections = {
			lualine_x = {
				{
					require("noice").api.status.mode.get,
					cond = require("noice").api.status.mode.has,
					color = { fg = "#ff9e64" },
				},
			},
			lualine_c = {
				{
					symbols.get,
					cond = symbols.has,
				},
			},
		},
	}
end

return M
