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
			-- Only for a real file: an empty path would search the whole project instead.
			local file = vim.api.nvim_buf_get_name(0)
			if vim.bo.buftype ~= "" or file == "" or not vim.uv.fs_stat(file) then
				vim.notify("Find & replace in current file: this buffer is not a saved file", vim.log.levels.WARN)
				return
			end
			-- The paths field is space-separated; grug-far only understands "\ " as an escaped space
			-- (fnameescape would also escape [ ] # %, which grug-far would then look for literally).
			local path = vim.fn.fnamemodify(file, ":."):gsub(" ", "\\ ")
			require("grug-far").open({ prefills = { paths = path } })
		end,
		mode = "n",
		desc = "Find & replace in current file",
	},
}

return M
