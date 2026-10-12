local M = {}

M.init = function()
	vim.g.db_ui_use_nerd_fonts = 1
	-- Saved connections and saved queries live here (connections.json + one folder per database)
	vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
end

M.cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" }

-- In the drawer: <CR> open/expand, A add connection, R redraw, d delete, ? help.
-- In a query buffer: <leader>S runs the query (or the selection).
M.keys = {
	{ "<leader>db", "<cmd>DBUIToggle<CR>", mode = "n", desc = "Toggle database UI (dadbod)" },
}

return M
