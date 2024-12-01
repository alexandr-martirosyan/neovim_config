local M = {}

M.opts = function()
	local cmp = require "cmp"

	return {
		completion = { completeopt = "menu,menuone" },

		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},

		window = {
			completion = {
				border = 'rounded',
				winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None,CursorLine:PmenuSel',
				scrollbar = true,
				-- max_width = 60, -- Set the maximum width of the completion window
				max_height = 10, -- Set the maximum height of the completion window
			},
			documentation = {
				border = 'rounded',
				winhighlight = 'Normal:CmpDoc,FloatBorder:CmpDocBorder,CursorLine:CmpDocSel',
				scrollbar = true,
				-- max_width = 60, -- Documentation window width
				max_height = 10, -- Documentation window height
			},
		},
		formatting = {
			fields = { 'abbr', 'kind', 'menu' },
			format = function(entry, vim_item)
				vim_item.kind = string.format('%s %s', require('lspkind').presets.default[vim_item.kind], vim_item.kind)
				vim_item.menu = ({
					nvim_lsp = '[LSP]',
					luasnip = '[Snippet]',
					buffer = '[Buffer]',
					path = '[Path]',
				})[entry.source.name]
				return vim_item
			end,
		},
		experimental = {
			ghost_text = true, -- Show ghost text for better inline completion visualization
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
			{
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			}
		},
	}
end

return M
