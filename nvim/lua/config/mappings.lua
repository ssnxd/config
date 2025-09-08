-- Key mappings and shortcuts
-- Define all custom key bindings and shortcuts

local set = vim.keymap.set

---------------------------------------------------------------------------
-- Leader key
---------------------------------------------------------------------------
vim.g.mapleader = " " -- Space as leader key
vim.g.maplocalleader = " " -- Space as local leader key

---------------------------------------------------------------------------
-- File operations
---------------------------------------------------------------------------
set("n", "<Leader>w", ":w<CR>", { desc = "Save file" })
set("n", "<Leader>q", ":bd<CR>", { desc = "Close buffer" })
set("n", "<Leader>Q", ":qa<CR>", { desc = "Quit all" })

---------------------------------------------------------------------------
-- Window navigation
---------------------------------------------------------------------------
-- Note: <C-k> is used for window navigation, LSP uses <C-s> for signature help
set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

---------------------------------------------------------------------------
-- Window resizing (LazyVim style)
---------------------------------------------------------------------------
set("n", "<leader><Up>", [[<cmd>resize +2<cr>]], { desc = "Increase window height" })
set("n", "<leader><Down>", [[<cmd>resize -2<cr>]], { desc = "Decrease window height" })
set("n", "<leader><Left>", [[<cmd>vertical resize -2<cr>]], { desc = "Decrease window width" })
set("n", "<leader><Right>", [[<cmd>vertical resize +2<cr>]], { desc = "Increase window width" })

---------------------------------------------------------------------------
-- Better line navigation (handle wrapped lines)
---------------------------------------------------------------------------
set("n", "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
set("n", "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

---------------------------------------------------------------------------
-- Better indenting (keep selection)
---------------------------------------------------------------------------
set("v", "<", "<gv", { desc = "Indent left" })
set("v", ">", ">gv", { desc = "Indent right" })

---------------------------------------------------------------------------
-- Move lines up/down
---------------------------------------------------------------------------
set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })

---------------------------------------------------------------------------
-- Utility
---------------------------------------------------------------------------
set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

---------------------------------------------------------------------------
-- Symbols outline (using aerial.nvim)
---------------------------------------------------------------------------
set("n", "<Leader>o", "<cmd>AerialToggle<CR>", { desc = "Toggle symbols outline" })
