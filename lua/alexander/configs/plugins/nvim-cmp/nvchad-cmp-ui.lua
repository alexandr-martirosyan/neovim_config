local M = {}

local nvchad_cmp_ui = {
	icons_left = false, -- only for non-atom styles!
	lspkind_text = true,
	style = "default", -- default/flat_light/flat_dark/atom/atom_colored
	format_colors = {
		tailwind = false, -- will work for css lsp too
		icon = "󱓻",
	},
}

M = nvchad_cmp_ui

return M
