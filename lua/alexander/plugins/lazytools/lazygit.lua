local M = {}

M.config = function(_, opts)
	require("telescope").load_extension("lazygit")
end

M.keys = {
	{
		"<leader>fg",
		"<cmd>lua require('telescope').extensions.lazygit.lazygit()<CR>",
		mode = "n",
		desc = "telescope lazygit",
	},
	{ "<leader>lg", "<cmd>LazyGit<cr>", mode = "n", desc = "LazyGit Toggle" },
}

return M
