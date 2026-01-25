-- lua/alexander/plugins/bufferline/bufferline.lua
local M = {}

M.opts = {
	options = {
		mode = "buffers",
		-- Replicates Barbar's 'slanted' preset [cite: 26, 75, 76]
		separator_style = "slant",
		diagnostics = "nvim_lsp",
		-- Matches your Barbar diagnostic setup [cite: 25, 34, 35, 129]
		diagnostics_indicator = function(count, level)
			local icon = level:match("error") and " " or (level:match("warning") and " " or " ")
			return " " .. icon .. count
		end,
		-- Keeps the tree explorer and tab bar separated [cite: 26, 46, 69]
		offsets = {
			{
				filetype = "neo-tree",
				text = "File Explorer",
				text_align = "center",
				separator = true,
			},
		},
		-- Visual refinements
		show_buffer_icons = true,
		show_buffer_close_icons = true,
		show_close_icon = true,
		persist_buffer_sort = true,
		tab_size = 18, -- [cite: 43, 67]
	},
}

return M
