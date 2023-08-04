local keyset = vim.keymap.set

-- <Space> as leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- map("i", "jj", "<Esc>")
keyset("n", "<Leader>s", ":w<CR>") -- save change
keyset("n", "<Leader>e", ":q<CR>") -- exit buffer

keyset("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
keyset("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
keyset("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
keyset("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

keyset("n", "<C-Down>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keyset("n", "<C-Up>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keyset("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keyset("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
