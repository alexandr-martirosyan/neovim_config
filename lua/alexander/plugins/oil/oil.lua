local M = {}

M.opts = {
	default_file_explorer = false,
	-- `-` opens Oil as a float. Without a border and size limit it filled the whole editor and looked
	-- like a normal window (the file's winbar and tabs stayed visible above it).
	float = {
		padding = 2,
		max_width = 0.8, -- 80% of the editor
		max_height = 0.8,
		border = "rounded", -- the border's title shows the current directory
	},
}

M.keys = {
	{ "-", "<CMD>Oil --float<CR>", mode = "n", desc = "Open parent directory" },
}

return M
