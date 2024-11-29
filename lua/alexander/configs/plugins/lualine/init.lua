local M = {}
-- local evli_lualine = require "alexander.configs.plugins.lualine.evli_lualine"
-- M.opts = evli_lualine.config;

M.opts = {
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
	},
}

return M
