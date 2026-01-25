local M = {}

M.opts = function()
	local cmp = require("cmp")
	local lspkind = require("lspkind")
	local compare = require("cmp.config.compare")

	lspkind.init({
		symbol_map = { Copilot = "" },
	})

	vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

	return {
		-- 1. BETTER SORTING (IntelliJ/VSCode Style)
		sorting = {
			priority_weight = 2,
			comparators = {
				compare.offset, -- Closer to cursor = better
				compare.exact, -- Exact matches first
				compare.score, -- LSP provided score (Crucial for rust-analyzer)
				compare.recently_used, -- Your most used items bubble up
				compare.locality, -- Prefer items in your current function/file
				compare.kind, -- Group similar types together
				compare.sort_text, -- Final fallback
				compare.length,
				compare.order,
			},
		},

		completion = { completeopt = "menu,menuone" },

		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},

		window = {
			completion = cmp.config.window.bordered({
				winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None,CursorLine:PmenuSel",
				scrollbar = false,
				side_padding = 0,
			}),
			documentation = cmp.config.window.bordered({
				winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder,CursorLine:CmpDocSel",
				scrollbar = false,
			}),
		},

		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				local kind = lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = 50,
					ellipsis_char = "...",
					show_labelDetails = true,
				})(entry, vim_item)

				local strings = vim.split(kind.kind, "%s", { trimempty = true })
				kind.kind = " " .. (strings[1] or "") .. " "

				local source_names = {
					copilot = "",
					nvim_lsp = "",
					luasnip = "󰩫",
					buffer = "󰂔",
					path = "󰉋",
				}
				kind.menu = source_names[entry.source.name] or entry.source.name

				return kind
			end,
		},

		experimental = {
			ghost_text = true,
		},

		mapping = {
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.close(),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					local entry = cmp.get_selected_entry()
					if not entry then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					end
					cmp.confirm()
				else
					fallback()
				end
			end, { "i", "s" }),
		},

		sources = {
			{ name = "copilot", group_index = 2 },
			{ name = "nvim_lsp", group_index = 2 },
			{ name = "luasnip", group_index = 2 },
			{ name = "buffer", group_index = 2 },
			{ name = "path", group_index = 2 },
			{ name = "lazydev", group_index = 0 },
		},
	}
end

return M

-- local M = {}
--
-- M.opts = function()
-- 	local cmp = require("cmp")
-- 	local lspkind = require("lspkind")
-- 	lspkind.init({
-- 		symbol_map = {
-- 			Copilot = "",
-- 		},
-- 	})
--
-- 	vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
--
-- 	return {
-- 		-- sorting = {
-- 		-- 	priority_weight = 2,
-- 		-- 	comparators = {
-- 		-- 		cmp.config.compare.recently_used, -- Recently used completions
-- 		-- 		-- cmp.config.compare.score, -- LSP scores
-- 		-- 		-- TODO: maybe need to be configured
-- 		-- 	},
-- 		-- },
-- 		completion = { completeopt = "menu,menuone" },
--
-- 		snippet = {
-- 			expand = function(args)
-- 				require("luasnip").lsp_expand(args.body)
-- 			end,
-- 		},
--
-- 		window = {
-- 			completion = {
-- 				border = "rounded",
-- 				winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None,CursorLine:PmenuSel",
-- 				scrollbar = true,
-- 				-- max_width = 60, -- Set the maximum width of the completion window
-- 				max_height = 10, -- Set the maximum height of the completion window
-- 			},
-- 			documentation = {
-- 				border = "rounded",
-- 				winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder,CursorLine:CmpDocSel",
-- 				scrollbar = true,
-- 				-- max_width = 60, -- Documentation window width
-- 				max_height = 10, -- Documentation window height
-- 			},
-- 		},
-- 		formatting = {
-- 			fields = { "abbr", "kind", "menu" },
-- 			format = function(entry, vim_item)
-- 				vim_item.kind = string.format("%s %s", require("lspkind").presets.default[vim_item.kind], vim_item.kind)
-- 				vim_item.menu = ({
-- 					copilot = "",
-- 					nvim_lsp = "[LSP]",
-- 					luasnip = "[Snippet]",
-- 					buffer = "[Buffer]",
-- 					path = "[Path]",
-- 				})[entry.source.name]
-- 				return vim_item
-- 			end,
-- 		},
-- 		experimental = {
-- 			ghost_text = true, -- Show ghost text for better inline completion visualization
-- 		},
--
-- 		mapping = {
-- 			["<C-p>"] = cmp.mapping.select_prev_item(),
-- 			["<C-n>"] = cmp.mapping.select_next_item(),
-- 			["<C-d>"] = cmp.mapping.scroll_docs(-4),
-- 			["<C-f>"] = cmp.mapping.scroll_docs(4),
-- 			["<C-Space>"] = cmp.mapping.complete(),
-- 			["<C-e>"] = cmp.mapping.close(),
--
-- 			["<Tab>"] = cmp.mapping(function(fallback)
-- 				-- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
-- 				if cmp.visible() then
-- 					local entry = cmp.get_selected_entry()
-- 					if not entry then
-- 						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
-- 					end
-- 					cmp.confirm()
-- 				else
-- 					fallback()
-- 				end
-- 			end, { "i", "s" }),
-- 		},
--
-- 		sources = {
-- 			{ name = "copilot", group_index = 2, priority = 1000 }, -- Add Copilot source
-- 			{ name = "nvim_lsp", group_index = 2 },
-- 			{ name = "luasnip", group_index = 2 },
-- 			{ name = "buffer", group_index = 2 },
-- 			{ name = "nvim_lua", group_index = 2 },
-- 			{ name = "path", group_index = 2 },
-- 			{
-- 				name = "lazydev",
-- 				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
-- 			},
-- 		},
-- 	}
-- end
--
-- return M
