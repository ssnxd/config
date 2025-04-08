local set = vim.keymap.set

-- <Space> as leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

set("n", "<Leader>s", ":w<CR>", { desc = "Save changes" })
set("n", "<Leader>e", ":bd<CR>", { desc = "Exit buffer" })

-- Window navigation
set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize windows
set("n", "=", [[<cmd>vertical resize +5<cr>]], { desc = "make the window biger vertically" })
set("n", "-", [[<cmd>vertical resize -5<cr>]], { desc = "make the window smaller vertically" })
set("n", "+", [[<cmd>horizontal resize +2<cr>]], { desc = "make the window bigger horizontally" })
set("n", "_", [[<cmd>horizontal resize -2<cr>]], { desc = "make the window smaller horizontally" })

-- Quick navigation (Less keystrokes)
set("n", "H", "5h", { desc = "Move left 5 times" })
set("n", "J", "5j", { desc = "Move down 5 times" })
set("n", "K", "5k", { desc = "Move up 5 times" })
set("n", "L", "5l", { desc = "Move right 5 times" })

-- Symbols using aerial.nvim
set("n", "<Leader>k", "<cmd>AerialToggle<CR>", { desc = "Toggle symbols" })
