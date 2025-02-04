local keyset = vim.keymap.set

-- <Space> as leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- map("i", "jj", "<Esc>")
keyset("n", "<Leader>s", ":w<CR>") -- save change
keyset("n", "<Leader>e", ":bd<CR>") -- exit buffer

keyset("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
keyset("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
keyset("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
keyset("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

keyset("n", "=", [[<cmd>vertical resize +5<cr>]]) -- make the window biger vertically
keyset("n", "-", [[<cmd>vertical resize -5<cr>]]) -- make the window smaller vertically
keyset("n", "+", [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger horizontally by pressing shift and =
keyset("n", "_", [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally by pressing shift and -
