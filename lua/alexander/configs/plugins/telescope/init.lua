local M = {}

M.opts = function()
	return {
		defaults = {
			prompt_prefix = "   ",
			selection_caret = " ",
			entry_prefix = " ",
			layout_config = {
				horizontal = {
					prompt_position = "top",
					preview_width = 0.55,
				},
				width = 0.87,
				height = 0.80,
			},
			mappings = {
				n = { ["q"] = require("telescope.actions").close },
			},
		},

		extensions_list = { "themes", "terms" },
		extensions = {
			fzf = {
				fuzzy = true,               -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case",   -- or "ignore_case" or "respect_case"
				-- the default case_mode is "smart_case"
			}
		}
	}
end

M.config = function(_, opts)
	require('telescope').setup(opts)
	require('telescope').load_extension('fzf')
	-- TODO: configure when configuring debugger
	-- Run the `configurations` picker from nvim-dap
	-- require('telescope').extensions.dap.configurations()
end

return M
