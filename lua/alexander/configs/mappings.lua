-- Core editor mappings. Plugin mappings live in their existing plugin modules.
local map = vim.keymap.set
-- local nomap = vim.keymap.del

-- map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
-- map("i", "<C-e>", "<End>", { desc = "move end of line" })
-- Disabled: never used; restores built-in <C-h> backspace, <C-j> new line, <C-k> digraphs
-- map("i", "<C-h>", "<Left>", { desc = "move left" })
-- map("i", "<C-l>", "<Right>", { desc = "move right" })
-- map("i", "<C-j>", "<Down>", { desc = "move down" })
-- map("i", "<C-k>", "<Up>", { desc = "move up" })

-- Moved to smart-splits (plugins/smart-splits): same keys, but they also cross into tmux panes
-- map({ "n", "x" }, "<C-h>", "<C-w>h", { desc = "switch window left" })
-- map({ "n", "x" }, "<C-l>", "<C-w>l", { desc = "switch window right" })
-- map({ "n", "x" }, "<C-j>", "<C-w>j", { desc = "switch window down" })
-- map({ "n", "x" }, "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<leader>ln", "<cmd>set nu!<CR>", { desc = "toggle line number" })
-- moved from <leader>rn, which is LSP rename in LSP buffers
map("n", "<leader>lr", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- Terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-------------------------------------- User ------------------------------------------

-- added maps
map("n", "<leader>dh", vim.diagnostic.open_float, { desc = "Open diagnostic window" })
map("n", "<leader>dt", "<cmd>DiagnosticsToggleVirtualText<CR>", { desc = "Toggle inline diagnostics" })

-- Resize with arrows
-- Moved to smart-splits (plugins/smart-splits): same keys, they move the border in that direction
-- and also resize tmux panes
-- map("n", "<C-S-j>", ":resize -1<CR>", { desc = "Decrease window size" })
-- map("n", "<C-S-k>", ":resize +1<CR>", { desc = "Increase windows size" })
-- map("n", "<C-S-h>", ":vertical resize -1<CR>", { desc = "Decrease window size (vertical)" })
-- map("n", "<C-S-l>", ":vertical resize +1<CR>", { desc = "Increase window size (vertical)" })

-- Move text up and down
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move text down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move text up" })

-- Visual --
-- Stay in indent mode
map("x", "<", "<gv^", { desc = "Stay in indent mode left" })
map("x", ">", ">gv^", { desc = "Stay in indent mode right" })

-- Move text up and down
-- Same as the Visual Block <A-j>/<A-k> below ("x" covers every Visual mode, but not Select mode)
-- map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
-- map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move text up" })
-- Disabled: use built-in Visual P (paste without overwriting the register, Neovim 0.7+)
-- map("v", "p", '"_dP', { desc = "Paste from 'other' register" })

-- Visual Block --
-- Move text up and down
-- Disabled: restores built-in Visual J (join lines) and K (look up keyword); <A-j>/<A-k> still move
-- map("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
-- map("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })
map("x", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
map("x", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Window split
map("n", "<leader>ss", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>sd", "<cmd>split<CR>", { desc = "Split window horizontally" })
-- Same, but across the whole screen instead of only the current window
map("n", "<leader>sD", "<cmd>botright split<CR>", { desc = "Split full width at the bottom" })
map("n", "<leader>sS", "<cmd>botright vsplit<CR>", { desc = "Split full height on the far right" })

-- Insert new line without entering insert mode
map("n", "<leader>o", 'o<ESC>0"_D', { desc = "New line without insert mode" })
map("n", "<leader>O", 'O<ESC>0"_D', { desc = "New line without insert mode" })
