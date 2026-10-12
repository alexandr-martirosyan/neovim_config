local M = {}

M.config = function(_, opts)
	vim.o.foldcolumn = "1" -- '0' is not bad
	vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
	vim.o.foldlevelstart = 99
	vim.o.foldenable = true

	require("ufo").setup({
		provider_selector = function(bufnr, filetype, buftype)
			if filetype == "bigfile" then
				return "" -- no folds for huge files (see big-file protection in configs/autocmds.lua)
			end
			return { "treesitter", "indent" }
		end,
	})
end

M.keys = {
	{
		"zR",
		function()
			require("ufo").openAllFolds()
		end,
		mode = "n",
		desc = "Open all folds",
	},
	{
		"zM",
		function()
			require("ufo").closeAllFolds()
		end,
		mode = "n",
		desc = "Close all folds",
	},
}

return M
