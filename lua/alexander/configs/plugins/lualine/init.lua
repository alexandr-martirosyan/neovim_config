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
			disabled_filetypes = {
				winbar = { "oil", "neo-tree", "NvimTree", "startify", "dashboard" }, -- Disable winbar for Neotree, NvimTree, and others
			},
		},
		-- sections = {
		-- 	lualine_c = { "filename" }, -- Display file name in the statusline
		-- },
		winbar = {
			-- Add space on the left
			lualine_a = {
				function()
					return " "
				end,
			},
			lualine_b = {
				{
					"filename",
					path = 4, -- Dynamically adjusts based on duplicate files (smart resolution)
					shorting_target = 30, -- Limits the path length (optional)
				},
				"filetype",
			},
			lualine_c = {},
			lualine_x = {}, -- Additional space after centering
			lualine_y = {}, -- Right section (empty to avoid clutter)
			lualine_z = {}, -- Keep the right side empty
		},
		inactive_winbar = {
			lualine_a = {
				function()
					return " "
				end,
			},
			lualine_b = {
				{
					"filename",
					path = 4, -- Dynamically adjusts based on duplicate files (smart resolution)
					shorting_target = 30, -- Limits the path length (optional)
				},
				"filetype",
			},
			lualine_c = {}, -- Center the file name
			lualine_x = {}, -- Additional space after centering
			lualine_y = {}, -- Right section (empty to avoid clutter)
			lualine_z = {}, -- Keep the right side empty
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
		-- extensions = {
		-- 	"lazy",
		-- 	"oil",
		-- 	"neo-tree",
		-- 	"trouble",
		-- },
	}
end

return M
