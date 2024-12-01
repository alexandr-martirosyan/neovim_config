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
			theme = "auto", -- Automatically match your colorscheme
			-- globalstatus = false, -- Separate statusline for each window
			-- component_separators = "|",
			-- section_separators = "",
		},
		-- sections = {
		-- 	lualine_c = { "filename" }, -- Display file name in the statusline
		-- },
		winbar = {
			lualine_a = {}, -- Left section (empty to avoid clutter)
			lualine_b = { "%=%t", "filetype" }, -- Additional space before centering
			lualine_c = {}, -- Center the file name
			lualine_x = {}, -- Additional space after centering
			lualine_y = {}, -- Right section (empty to avoid clutter)
			lualine_z = {}, -- Keep the right side empty
		},
		inactive_winbar = {
			lualine_a = {}, -- Left section (empty to avoid clutter)
			lualine_b = { "%=%t", "filetype" }, -- Additional space before centering
			lualine_c = {}, -- Center the file name
			lualine_x = {}, -- Additional space after centering
			lualine_y = {}, -- Right section (empty to avoid clutter)
			lualine_z = {}, -- Keep the right side empty
		},
		sections = {
			lualine_x = {
				{
					require("noice").api.statusline.mode.get,
					cond = require("noice").api.statusline.mode.has,
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
