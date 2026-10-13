local M = {}

-- Same per-source menu icons as the previous nvim-cmp `formatting.format`.
local source_icons = {
	copilot = "",
	lsp = "",
	snippets = "󰩫",
	buffer = "󰂔",
	path = "󰉋",
}

-- nvim-cmp's `compare.kind`: snippets first, plain Text last, otherwise by LSP kind number.
local function cmp_kind(a, b)
	local text, snippet = vim.lsp.protocol.CompletionItemKind.Text, vim.lsp.protocol.CompletionItemKind.Snippet
	local ka = a.kind == text and 100 or a.kind
	local kb = b.kind == text and 100 or b.kind
	if ka == kb then
		return nil
	end
	if ka == snippet then
		return true
	end
	if kb == snippet then
		return false
	end
	return ka < kb
end

-- nvim-cmp's `compare.length`: shorter labels first.
local function cmp_length(a, b)
	if #a.label ~= #b.label then
		return #a.label < #b.label
	end
end

M.opts = function()
	require("lspkind").init({
		symbol_map = { Copilot = "" },
	})

	return {
		-- Same keys as the previous nvim-cmp mapping table; "none" adds no extra blink defaults.
		keymap = {
			preset = "none",
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<C-d>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<C-Space>"] = { "show" },
			["<C-e>"] = { "hide", "fallback" },
			-- Menu open: accept the selected item (or the first one).
			-- Otherwise expand/jump the LuaSnip snippet, then fall back to a normal <Tab>.
			["<Tab>"] = {
				function(cmp)
					if cmp.is_menu_visible() then
						return cmp.select_and_accept()
					end
				end,
				function()
					local luasnip = require("luasnip")
					if luasnip.expand_or_locally_jumpable() then
						vim.schedule(luasnip.expand_or_jump)
						return true
					end
				end,
				-- Also makes blink map <Tab> in select mode, where LuaSnip placeholders are.
				"snippet_forward",
				"fallback",
			},
			["<S-Tab>"] = {
				function()
					local luasnip = require("luasnip")
					if luasnip.locally_jumpable(-1) then
						vim.schedule(function()
							luasnip.jump(-1)
						end)
						return true
					end
				end,
				"snippet_backward",
				"fallback",
			},
		},

		snippets = { preset = "luasnip" },

		-- 1. BETTER SORTING (IntelliJ/VSCode Style), mirroring the old comparator order.
		-- Frecency (recently_used) and proximity (locality) are part of blink's score.
		fuzzy = {
			sorts = { "exact", "score", cmp_kind, "sort_text", cmp_length },
		},

		completion = {
			list = { selection = { preselect = true, auto_insert = true } },
			-- Brackets after accepting a function (previously nvim-autopairs' cmp hook).
			accept = { auto_brackets = { enabled = true } },
			menu = {
				border = "rounded",
				winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
				scrollbar = false,
				draw = {
					padding = 0,
					columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_icon" } },
					components = {
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								return " " .. (require("lspkind").symbol_map[ctx.kind] or ctx.kind_icon) .. " "
							end,
						},
						label = { width = { fill = true, max = 50 } },
						source_icon = {
							ellipsis = false,
							text = function(ctx)
								return source_icons[ctx.source_id] or ctx.source_name
							end,
							highlight = "BlinkCmpSource",
						},
					},
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 0,
				window = {
					border = "rounded",
					winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder,CursorLine:CmpDocSel",
					scrollbar = false,
				},
			},
			ghost_text = { enabled = true },
		},

		sources = {
			default = { "copilot", "lsp", "snippets", "buffer", "path" },
			per_filetype = {
				lua = { inherit_defaults = true, "lazydev" },
				-- vim-dadbod-completion: table/column names from the connected database
				sql = { "snippets", "dadbod", "buffer" },
				mysql = { "snippets", "dadbod", "buffer" },
				plsql = { "snippets", "dadbod", "buffer" },
				-- Avante's own (nvim-cmp style) sources, bridged through blink.compat.
				AvanteInput = { "avante_commands", "avante_mentions", "avante_shortcuts" },
				AvantePromptInput = { "avante_prompt_mentions" },
			},
			providers = {
				-- nvim-cmp showed buffer words together with LSP items; blink hides them unless LSP is empty.
				lsp = { fallbacks = {} },
				copilot = { name = "copilot", module = "blink-copilot", async = true },
				lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
				dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
				avante_commands = { name = "avante_commands", module = "blink.compat.source", score_offset = 90 },
				avante_mentions = { name = "avante_mentions", module = "blink.compat.source", score_offset = 1000 },
				avante_shortcuts = { name = "avante_shortcuts", module = "blink.compat.source", score_offset = 1000 },
				avante_prompt_mentions = {
					name = "avante_prompt_mentions",
					module = "blink.compat.source",
					score_offset = 1000,
				},
			},
		},

		-- nvim-cmp had no command-line completion (cmp-cmdline was disabled).
		cmdline = { enabled = false },
		signature = { enabled = false },
	}
end

return M
