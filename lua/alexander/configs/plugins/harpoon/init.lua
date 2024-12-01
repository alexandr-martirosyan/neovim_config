local M = {}

M.config = function(_, opts)
	local harpoon = require("harpoon")

	-- REQUIRED
	harpoon:setup()
	-- REQUIRED
	local map = vim.keymap.set

	-- basic telescope configuration
	local conf = require("telescope.config").values
	local function toggle_telescope(harpoon_files)
		local file_paths = {}
		for _, item in ipairs(harpoon_files.items) do
			table.insert(file_paths, item.value)
		end

		require("telescope.pickers")
			.new({}, {
				prompt_title = "Harpoon",
				finder = require("telescope.finders").new_table({
					results = file_paths,
				}),
				previewer = conf.file_previewer({}),
				sorter = conf.generic_sorter({}),
			})
			:find()
	end

	map("n", "<leader>hi", function()
		harpoon.ui:toggle_quick_menu(harpoon:list())
	end, { desc = "open harpoon ui" })
	map("n", "<leader>a", function()
		harpoon:list():add()
	end, { desc = "harpoon list add" })
	map("n", "<leader>fp", function()
		toggle_telescope(harpoon:list())
	end, { desc = "telescope open harpoon window" })

	-- Toggle previous & next buffers stored within Harpoon list
	map("n", "<C-S-P>", function()
		harpoon:list():prev()
	end, { desc = "harpoon list prev" })
	map("n", "<C-S-N>", function()
		harpoon:list():next()
	end, { desc = "harpoon list prev" })
end

-- TODO: Maybe add harpoon ui too

return M
