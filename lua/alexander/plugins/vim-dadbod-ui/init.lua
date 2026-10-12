local dadbod = require("alexander.plugins.vim-dadbod-ui.vim-dadbod-ui")

local M = {
	{
		-- Database UI inside Neovim (replaces nvim-dbee). Uses your installed clients (psql, mysql, ...).
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			-- SQL completion (tables, columns) for blink.cmp; see blink-cmp/blink-cmp.lua
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = dadbod.cmd,
		keys = dadbod.keys,
		init = dadbod.init,
	},
}

return M
