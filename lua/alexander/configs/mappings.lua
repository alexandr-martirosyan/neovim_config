local map = vim.keymap.set
-- local nomap = vim.keymap.del

-- map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
-- map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map("n", "<leader>ln", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

map("n", "<leader>fm", function()
	require("conform").format({
		lsp_format = "fallback",
		stop_after_first = true,
	})
end, { desc = "general format file" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- barbar
-- Move to previous/next
-- map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', { desc = "buffer goto previous" })
-- map('n', '<A-.>', '<Cmd>BufferNext<CR>', { desc = "buffer goto next" })
map("n", "<S-h>", "<Cmd>BufferPrevious<CR>", { desc = "buffer goto previous" })
map("n", "<S-l>", "<Cmd>BufferNext<CR>", { desc = "buffer goto next" })
-- Re-order to previous/next
map("n", "<A-,>", "<Cmd>BufferMovePrevious<CR>", { desc = "buffer move previous" })
map("n", "<A-.>", "<Cmd>BufferMoveNext<CR>", { desc = "buffer move next" })
-- Goto buffer in position...
map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", { desc = "buffer goto 1" })
map("n", "<A-0>", "<Cmd>BufferLast<CR>", { desc = "buffer goto last" })
-- map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
-- map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
-- map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
-- map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
-- map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
-- map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
-- map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
-- map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
-- Pin/unpin buffer
map("n", "<A-p>", "<Cmd>BufferPin<CR>", { desc = "buffer pin" })
-- Goto pinned/unpinned buffer
--                 :BufferGotoPinned
--                 :BufferGotoUnpinned
-- Close buffer
map("n", "<leader>x", "<Cmd>BufferClose<CR>", { desc = "buffer close" })
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
map("n", "<A-S-p>", "<Cmd>BufferPick<CR>", { desc = "buffer pick" })
-- Sort automatically by...
map("n", "<leader>bb", "<Cmd>BufferOrderByBufferNumber<CR>", { desc = "buffer order by buffer number" })
map("n", "<leader>bn", "<Cmd>BufferOrderByName<CR>", { desc = "buffer order by name" })
map("n", "<leader>bd", "<Cmd>BufferOrderByDirectory<CR>", { desc = "buffer order by directory" })
map("n", "<leader>bl", "<Cmd>BufferOrderByLanguage<CR>", { desc = "buffer order by language" })
map("n", "<leader>bw", "<Cmd>BufferOrderByWindowNumber<CR>", { desc = "buffer order by window number" })

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used

-- Terminal
map({ "n", "t" }, "<A-v>", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "terminal toggleable vertical term" })
map({ "n", "t" }, "<A-h>", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "terminal toggleable horizontal term" })
map({ "n", "t" }, "<A-i>", "<cmd>ToggleTerm direction=float<cr>", { desc = "terminal toggleable float term" })
map({ "n", "t" }, "<A-t>", "<cmd>ToggleTerm direction=tab<cr>", { desc = "terminal toggleable tab term" })

-- neotree
map("n", "<C-n>", "<cmd>Neotree toggle<CR>", { desc = "neotree toggle window" })
map("n", "<leader>e", "<cmd>Neotree focus<CR>", { desc = "neotree focus window" })

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
map("n", "<leader>fg", "<cmd>lua require('telescope').extensions.lazygit.lazygit()<CR>", { desc = "telescope lazygit" })
map("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = 'telescope find "TODO"-s' })

map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
	"n",
	"<leader>fa",
	"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
	{ desc = "telescope find all files" }
)

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
	vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "whichkey query lookup" })

-------------------------------------- User ------------------------------------------

-- added maps
map("n", "<leader>ll", function()
	require("lint").try_lint()
end, { desc = "Trigger linting for current file" })
map("n", "<leader>dh", vim.diagnostic.open_float, { desc = "Open diagnostic window" })
map("n", "<leader>dt", "<cmd>DiagnosticsToggleVirtualText<CR>", { desc = "Toggle inline diagnostics" })

-- Resize with arrows
map("n", "<C-S-j>", ":resize -1<CR>", { desc = "Decrease window size" })
map("n", "<C-S-k>", ":resize +1<CR>", { desc = "Increase windows size" })
map("n", "<C-S-h>", ":vertical resize -1<CR>", { desc = "Decrease window size (vertical)" })
map("n", "<C-S-l>", ":vertical resize +1<CR>", { desc = "Increase window size (vertical)" })

-- Move text up and down
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move text down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move text up" })

-- Visual --
-- Stay in indent mode
map("v", "<", "<gv^", { desc = "Stay in indent mode left" })
map("v", ">", ">gv^", { desc = "Stay in indent mode right" })

-- Move text up and down
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move text up" })
map("v", "p", '"_dP', { desc = "Paste from 'other' register" })

-- Visual Block --
-- Move text up and down
map("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
map("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })
map("x", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
map("x", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Window split
map("n", "<leader>ss", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>sd", "<cmd>split<CR>", { desc = "Split window horizontally" })

-- Insert new line without entering insert mode
map("n", "<leader>o", 'o<ESC>0"_D', { desc = "New line without insert mode" })
map("n", "<leader>O", 'O<ESC>0"_D', { desc = "New line without insert mode" })

-- gitsigns
map("n", "]c", function()
	if vim.wo.diff then
		vim.cmd.normal({ "]c", bang = true })
	else
		require("gitsigns").nav_hunk("next")
	end
end, { desc = "Gitsigns prev hunk" })

map("n", "[c", function()
	if vim.wo.diff then
		vim.cmd.normal({ "[c", bang = true })
	else
		require("gitsigns").nav_hunk("prev")
	end
end, { desc = "Gitsigns prev hunk" })

-- Actions
map("n", "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Gitsigns stage hunk [n]" })
map("n", "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Gitsigns reset hunk [n]" })
map("v", "<leader>hs", function()
	require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Gitsigns stage hunk [v]" })
map("v", "<leader>hr", function()
	require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Gitsigns reset hunk [v]" })
map("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>", { desc = "Gitsigns stage buffer" })
map("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Gitsigns undo stake hunk" })
map("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>", { desc = "Gitsigns reset buffer" })
map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Gitsigns preview hunk" })
map("n", "<leader>hb", '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', { desc = "Gitsigns blame line" })
map("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Gitsigns toggle current line blame" })
map("n", "<leader>hd", "<cmd>Gitsigns diffthis<CR>", { desc = "Gitsigns Gitsigns diff this" })
map("n", "<leader>hD", '<cmd>lua require"gitsigns".diffthis("~")<CR>', { desc = "Gitsigns diff this" })
map("n", "<leader>td", "<cmd>Gitsigns toggle_deleted<CR>", { desc = "Gitsigns toggle deleted" })
-- Text object
map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Gitsigns select hunk" })
-- LazyGit 
map("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "LazyGit Toggle" })
-- LazyDocker
map("n", "<leader>ld", "<cmd>LazyDocker<CR>", { desc = "LazyDocker Toggle" })

-- WhichKey
map("n", "<leader>?", function()
	require("which-key").show()
end, { desc = "Buffer Local Keymaps (which-key)" })

-- TodoComments
map("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

map("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

-- Trouble
map("n", "<leader>zx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>zX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
map(
	"n",
	"<leader>cl",
	"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	{ desc = "LSP Definitions / references / ... (Trouble)" }
)
map("n", "<leader>zL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>zQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

-- Oil
map("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

-- Neogit
map("n", "<leader>ng", "<CMD>Neogit<CR>", { desc = "Open Neogit tab" })

-- winshift
map("n", "<C-W><C-M>", "<Cmd>WinShift<CR>", { desc = "Activate WinShift" })
map("n", "<C-W>m", "<Cmd>WinShift<CR>", { desc = "Activate WinShift" })
map("n", "<C-W>X", "<Cmd>WinShift swap<CR>", { desc = "Activate WinShift SWAP" })

-- folding
map("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
map("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
