local M = {}

M.opts = function()
	local cmp = require "cmp"

	local cmp_ui = require "alexander.configs.plugins.nvim-cmp.nvchad-cmp-ui"
	local cmp_style = cmp_ui.style
	local format_kk = require "alexander.configs.plugins.nvim-cmp.format"

	local atom_styled = cmp_style == "atom" or cmp_style == "atom_colored"
	local fields = (atom_styled or cmp_ui.icons_left) and { "kind", "abbr", "menu" } or { "abbr", "kind", "menu" }
	return {
		-- NVChad options
		formatting = {
			format = function(entry, item)
				local icons = require "alexander.configs.nvchad.icons.lspkind"

				item.abbr = item.abbr .. " "
				item.menu = cmp_ui.lspkind_text and item.kind or ""
				item.menu_hl_group = atom_styled and "LineNr" or "CmpItemKind" .. (item.kind or "")
				item.kind = (icons[item.kind] or "") .. " "

				if not cmp_ui.icons_left then
					item.kind = " " .. item.kind
				end

				if cmp_ui.format_colors.tailwind then
					format_kk.tailwind(entry, item)
				end

				return item
			end,

			fields = fields,
		},

		window = {
			completion = {
				scrollbar = false,
				side_padding = atom_styled and 0 or 1,
				winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None,FloatBorder:CmpBorder",
				border = atom_styled and "none" or "single",
			},

			documentation = {
				border = "single",
				winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
			},
		},
		-- Other configs
		completion = { completeopt = "menu,menuone" },

		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},

		mapping = {
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.close(),

			["<Tab>"] = cmp.mapping(function(fallback)
				-- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
				if cmp.visible() then
					local entry = cmp.get_selected_entry()
					if not entry then
						cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
					end
					cmp.confirm()
				else
					fallback()
				end
			end, { "i", "s" }),
		},

		sources = {
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "buffer" },
			{ name = "nvim_lua" },
			{ name = "path" },
		},
	}
end

return M
