local M = {}

M.opts = function(_, opts)
	local actions = require("telescope.actions")
	local open_with_trouble = require("trouble.sources.telescope").open

	-- Use this to add more results without clearing the trouble list
	local add_to_trouble = require("trouble.sources.telescope").add

	return {
		defaults = {
			prompt_prefix = "   ",
			selection_caret = " ",
			entry_prefix = " ",
			layout_strategy = "flex",
			layout_config = {
				preview_cutoff = 0, -- always show preview below if in vertical
				horizontal = {
					prompt_position = "top",
					preview_width = 0.55,
				},
				vertical = {
					prompt_position = "top",
					mirror = true, -- 👈 This flips the layout vertically
					preview_height = 0.64,
					preview_cutoff = 0, -- always show preview below if in vertical
				},
				flex = {
					flip_columns = 160, -- if window is narrower than 100 columns, use vertical layout
				},
				width = 0.87,
				height = 0.80,
			},
			mappings = {
				i = { ["<c-t>"] = open_with_trouble },
				n = {
					["<c-t>"] = open_with_trouble,
					["q"] = actions.close,
				},
			},
		},

		extensions_list = { "themes", "terms" },
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				-- the default case_mode is "smart_case"
			},
			["ui-select"] = {
				require("telescope.themes").get_dropdown({}),
			},
		},
	}
end

M.config = function(_, opts)
	local telescope = require("telescope")
	telescope.setup(opts)
	telescope.load_extension("fzf")
	telescope.load_extension("frecency")
	telescope.load_extension("media_files")
	telescope.load_extension("ui-select")

	-- TODO: configure when configuring debugger
	-- Run the `configurations` picker from nvim-dap
	-- require('telescope').extensions.dap.configurations()
end

return M
