---@diagnostic disable: undefined-field
local M = {}

---@diagnostic disable-next-line: unused-local
M.opts = function(_, opts)
	-- Create a master group for the pill container
	-- vim.api.nvim_set_hl(0, "LualineTroublePill", { bg = "#313244", fg = "#cdd6f4" })
	-- vim.api.nvim_set_hl(0, "LualineNoicePill", { bg = "#313244", fg = "#ff9e64" })
	local trouble = require("trouble")
	local symbols = trouble.statusline({
		mode = "lsp_document_symbols",
		groups = {},
		title = false,
		filter = { range = true },
		format = "{kind_icon}{symbol.name:Normal}",
		-- The following line is needed to fix the background color
		-- Set it to the lualine section you want to use
		-- hl_group = "LualinetroublePill",
		-- hl_group = "#181926",
	})
	-- 1. THEME OVERRIDE: Inherit from 'auto'
	-- We use a deep "Crust" background to make the bar stand out as a separator.
	local custom_theme = require("lualine.themes.auto")
	-- custom_theme.normal.c.bg = "#181926" -- Very dark active background
	custom_theme.inactive.c.bg = "#181926" -- Very dark active background
	custom_theme.normal.c.bg = "#11111b" -- Near-black inactive background

	-- Spacer for layout control
	local spacer = {
		function()
			return "%="
		end,
		separator = "",
	}

	-- ========================================================================
	-- COMPONENT DEFINITIONS
	-- ========================================================================

	-- 1. FILEPATH (Straight Left, Semicircle Right)
	local filename_active = {
		"filename",
		path = 1,
		shorting_target = 30,
		color = {
			bg = "#494d64",
			fg = "#7dc4e4" --[[ , gui = "bold" ]],
		},
		-- color = "lualine_b",
		-- color = "lualine_a_normal", -- Restored your Bold/Colorful primary color
		separator = { left = "", right = "" },
		padding = { left = 1, right = 1 },
	}

	local filename_inactive = {
		"filename",
		path = 1,
		shorting_target = 30,
		color = { bg = "#363a4f", fg = "#a5adce" },
		-- color = "lualine_c_inactive",
		separator = { left = "", right = "" },
		padding = { left = 1, right = 1 },
	}

	-- 2. BRANCH (Semicircle both sides, Subtle Gray background)
	local branch_active = {
		"branch",
		icon = "",
		-- RESTORED: Your preferred subtle gray highlight
		-- color = { bg = "#45475a", fg = "#cdd6f4" },
		color = "lualine_b_visual",
		separator = { left = "", right = "" },
		padding = { left = 1, right = 1 },
	}

	local branch_inactive = {
		"branch",
		icon = "",
		color = { bg = "#313244", fg = "#a5adce" },
		separator = { left = "", right = "" },
		padding = { left = 1, right = 1 },
	}

	-- 3. FILETYPE (Semicircle Left, Straight Right)
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
		color = { bg = "#363a4f", fg = "#a5adce" },
		separator = { left = "", right = "" },
		padding = { left = 1, right = 1 },
	}

	return {
		options = {
			theme = custom_theme,
			section_separators = { left = "", right = "" },
			component_separators = { left = "", right = "" }, -- Keeps the inside of pills clean
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

		-- ACTIVE WINDOW: {filepath   branch ----------------------- filetype}
		winbar = {
			lualine_a = {},
			lualine_b = { filename_active, branch_active },
			lualine_c = { spacer },
			lualine_x = {},
			lualine_y = { filetype_active },
			lualine_z = {},
		},

		-- INACTIVE WINDOW
		inactive_winbar = {
			lualine_a = {},
			lualine_b = { filename_inactive, branch_inactive },
			lualine_c = { spacer },
			lualine_x = {},
			lualine_y = { filetype_inactive },
			lualine_z = {},
		},

		sections = {
			lualine_x = {
				{
					-- Wrapping in a function strips Noice's internal highlights
					require("noice").api.status.message.get_hl,
					cond = require("noice").api.status.message.has,
					color = "LualineMessagePill",
					separator = { left = "", right = "" },
				},
			},
			lualine_c = {
				{
					symbols.get,
					cond = symbols.has,
					separator = { left = "", right = "" },
				},
			},
		},
	}
end

return M
