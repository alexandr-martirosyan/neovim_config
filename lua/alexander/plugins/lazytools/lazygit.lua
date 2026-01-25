local M = {}

M.config = function(_, opts)
	require("telescope").load_extension("lazygit")
end

return M
