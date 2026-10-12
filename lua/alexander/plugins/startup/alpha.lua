local M = {}

M.config = function(_, opts)
	local dashboard = require("alpha.themes.dashboard")
	local button = dashboard.button

	-- Press the letter on the start screen (or move to a line and press Enter).
	-- The default theme's buttons pointed at someone else's keys (SPC f h / SPC f m / SPC s l).
	dashboard.section.buttons.val = {
		button("e", "  New file", "<cmd>ene <BAR> startinsert<CR>"),
		button("f", "󰈞  Find file", "<cmd>Telescope find_files<CR>"),
		button("r", "  Recent files (frequent first)", "<cmd>Telescope frecency<CR>"),
		button("o", "󰋚  Recent files (latest first)", "<cmd>Telescope oldfiles<CR>"),
		button("g", "󰈬  Find text in project", "<cmd>Telescope live_grep<CR>"),
		button("s", "  Restore session for this folder", "<cmd>AutoSession restore<CR>"),
		button("t", "󰙅  File tree", "<cmd>Neotree focus<CR>"),
		button("n", "  Git (Neogit)", "<cmd>Neogit<CR>"),
		button("l", "  Git (LazyGit)", "<cmd>LazyGit<CR>"),
		button("c", "  Neovim config", "<cmd>Telescope find_files cwd=" .. vim.fn.stdpath("config") .. "<CR>"),
		button("L", "󰒲  Plugins (Lazy)", "<cmd>Lazy<CR>"),
		button("m", "  Language tools (Mason)", "<cmd>Mason<CR>"),
		button("h", "  Check health", "<cmd>checkhealth<CR>"),
		button("q", "  Quit", "<cmd>qa<CR>"),
	}

	local v = vim.version()
	local stats = require("lazy").stats()
	dashboard.section.footer.val = ("Neovim v%d.%d.%d  ·  %d plugins"):format(v.major, v.minor, v.patch, stats.count)

	require("alpha").setup(dashboard.config)
end

return M
