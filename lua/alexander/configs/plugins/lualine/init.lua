local M = {}

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

	-- Spacer
	local spacer = {
		function()
			return "%="
		end,
		separator = "",
	}

	-- ========================================================================
	-- COMPONENT DEFINITIONS
	-- ========================================================================

	-- 1. LEFT SIDE: Git Branch (Now matches Right Side colors)
	local branch_active = {
		"branch",
		icon = "",
		-- REMOVED "lualine_a_normal" so it is not Blue anymore.
		-- It now uses the default WinBar background (Gray-like).
		colored = false,
		separator = { left = "", right = "" },
		padding = { left = 1, right = 1 },
	}

	local branch_inactive = {
		"branch",
		icon = "",
		color = { fg = "#a5adce" }, -- Simple Grey text
		separator = { left = "", right = "" },
		padding = { left = 1, right = 1 },
	}

	-- 2. CENTER: Filename (Keep as the bold "Pill")
	local filename_active = {
		"filename",
		path = 1,
		shorting_target = 30,
		color = "lualine_a_normal", -- This stays Bold/Colorful
		separator = { left = "", right = "" },
		padding = 1,
	}

	local filename_inactive = {
		"filename",
		path = 1,
		shorting_target = 30,
		color = { bg = "#363a4f", fg = "#a5adce", gui = "bold" },
		separator = { left = "", right = "" },
		padding = 1,
	}

	-- 3. RIGHT SIDE: Filetype (Original Gray-like look)
	local filetype_active = {
		"filetype",
		colored = true,
		icon_only = false,
		separator = { left = "", right = "" },
		padding = { left = 1, right = 1 },
	}

	local filetype_inactive = {
		"filetype",
		colored = false,
		color = { fg = "#a5adce" },
		separator = { left = "", right = "" },
		padding = { left = 1, right = 1 },
	}

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
					"toggleterm",
				},
			},
		},

		-- ACTIVE WINDOW
		winbar = {
			lualine_a = {},
			lualine_b = { branch_active }, -- LEFT (Gray-like)
			lualine_c = {
				spacer,
				filename_active, -- CENTER (Blue/Bold Pill)
			},
			lualine_x = {},
			lualine_y = { filetype_active }, -- RIGHT (Gray-like)
			lualine_z = {},
		},

		-- INACTIVE WINDOW
		inactive_winbar = {
			lualine_a = {},
			lualine_b = { branch_inactive },
			lualine_c = {
				spacer,
				filename_inactive,
			},
			lualine_x = {},
			lualine_y = { filetype_inactive },
			lualine_z = {},
		},

		sections = {
			lualine_x = {
				{
					require("noice").api.status.mode.get,
					cond = require("noice").api.status.mode.has,
					color = { fg = "#ff9e64" },
				},
			},
			lualine_c = { { symbols.get, cond = symbols.has } },
		},
	}
end

return M
