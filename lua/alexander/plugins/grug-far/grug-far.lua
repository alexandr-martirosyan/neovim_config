local M = {}

-- Options: see :h grug-far (there are no required options).
-- Inside the panel, keys use <localleader> (\): \r replace all, \s sync edited lines, \q results to quickfix,
-- \c close. Press g? in the panel for the full list.
M.opts = {}

M.keys = {
	{
		"<leader>fs",
		function()
			require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
		end,
		mode = "n",
		desc = "Find & replace in project (word under cursor)",
	},
	{
		"<leader>fs",
		function()
			require("grug-far").with_visual_selection()
		end,
		mode = "x",
		desc = "Find & replace in project (selection)",
	},
	{
		"<leader>fS",
		function()
			require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
		end,
		mode = "n",
		desc = "Find & replace in current file",
	},
}

return M
