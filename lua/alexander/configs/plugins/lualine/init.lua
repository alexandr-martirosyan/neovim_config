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
		-- The following line is needed to fix the background color
		-- Set it to the lualine section you want to use
		hl_group = "lualine_c_normal",
	})
	return {
		options = {
			theme = "catppuccin"
		},
		sections = {
			lualine_x = {
				{
					require("noice").api.statusline.mode.get,
					cond = require("noice").api.statusline.mode.has,
					color = { fg = "#ff9e64" },
				}
			},
			lualine_c = {
				{
					symbols.get,
					cond = symbols.has,
				}
			}
		},
	}
end

-- M.config = function(_, opts)
-- 	local lualine = require("lualine")
-- 	local trouble = require("trouble")
-- 	local symbols = trouble.statusline({
-- 		mode = "lsp_document_symbols",
-- 		groups = {},
-- 		title = false,
-- 		filter = { range = true },
-- 		format = "{kind_icon}{symbol.name:Normal}",
-- 		-- The following line is needed to fix the background color
-- 		-- Set it to the lualine section you want to use
-- 		hl_group = "lualine_c_normal",
-- 	})
-- 	table.insert(opts.sections.lualine_c, {
-- 		symbols.get,
-- 		cond = symbols.has,
-- 	})
-- 	lualine.setup(opts)
-- end

return M
