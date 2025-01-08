-- disable netrw for nvim-tree
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

vim.o.backup = false
vim.o.writebackup = false

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.relativenumber = true
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.showtabline = 2
vim.o.syntax = "enable"

vim.g.have_nerd_font = true

-- Session restore
vim.opt.sessionoptions = "curdir,folds,globals,help,tabpages,terminal,winsize"
