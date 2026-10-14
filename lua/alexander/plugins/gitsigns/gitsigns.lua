local M = {}

M.opts = {}

-- Git hunk keys live under <leader>g (was <leader>h), next to <leader>gt (git status).
M.keys = {
	{
		"]c",
		function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				require("gitsigns").nav_hunk("next")
			end
		end,
		mode = "n",
		desc = "Gitsigns next hunk",
	},
	{
		"[c",
		function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				require("gitsigns").nav_hunk("prev")
			end
		end,
		mode = "n",
		desc = "Gitsigns prev hunk",
	},
	{ "<leader>gs", ":Gitsigns stage_hunk<CR>", mode = "n", desc = "Gitsigns stage hunk [n]" },
	{ "<leader>gr", ":Gitsigns reset_hunk<CR>", mode = "n", desc = "Gitsigns reset hunk [n]" },
	{
		"<leader>gs",
		function()
			require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end,
		mode = "x",
		desc = "Gitsigns stage hunk [v]",
	},
	{
		"<leader>gr",
		function()
			require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end,
		mode = "x",
		desc = "Gitsigns reset hunk [v]",
	},
	{ "<leader>gS", "<cmd>Gitsigns stage_buffer<CR>", mode = "n", desc = "Gitsigns stage buffer" },
	{ "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", mode = "n", desc = "Gitsigns undo stage hunk" },
	{ "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", mode = "n", desc = "Gitsigns reset buffer" },
	{ "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", mode = "n", desc = "Gitsigns preview hunk" },
	{ "<leader>gb", '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', mode = "n", desc = "Gitsigns blame line" },
	{
		"<leader>tb",
		"<cmd>Gitsigns toggle_current_line_blame<CR>",
		mode = "n",
		desc = "Gitsigns toggle current line blame",
	},
	{ "<leader>gd", "<cmd>Gitsigns diffthis<CR>", mode = "n", desc = "Gitsigns diff this" },
	{ "<leader>gD", '<cmd>lua require"gitsigns".diffthis("~")<CR>', mode = "n", desc = "Gitsigns diff this against the commit before HEAD (~)" },
	{ "<leader>td", "<cmd>Gitsigns toggle_deleted<CR>", mode = "n", desc = "Gitsigns toggle deleted" },
	{ "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = { "o", "x" }, desc = "Gitsigns select hunk" },
}

return M
