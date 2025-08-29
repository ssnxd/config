-- Core Neovim settings and options
-- Configure editor behavior, UI, and performance

---------------------------------------------------------------------------
-- Performance
---------------------------------------------------------------------------
vim.o.backup = false          -- Don't create backup files
vim.o.writebackup = false     -- Don't create backup before overwriting
vim.o.swapfile = false        -- Disable swap files
vim.o.undofile = true         -- Enable persistent undo
vim.o.updatetime = 200        -- Faster completion (default: 4000ms)
vim.o.timeoutlen = 300        -- Time to wait for mapped sequence

---------------------------------------------------------------------------
-- UI/UX
---------------------------------------------------------------------------
vim.o.termguicolors = true    -- Enable 24-bit RGB color
vim.o.cursorline = true       -- Highlight current line
vim.o.number = true           -- Show line numbers
vim.o.relativenumber = true   -- Show relative line numbers
vim.o.signcolumn = "yes"      -- Always show sign column
vim.o.showmode = false        -- Don't show mode (lualine shows it)
vim.o.showtabline = 2         -- Always show tabline
vim.o.laststatus = 3          -- Global statusline across splits
vim.o.cmdheight = 1           -- Command line height
vim.o.pumheight = 10          -- Popup menu height
vim.o.scrolloff = 8           -- Lines to keep above/below cursor
vim.o.sidescrolloff = 8       -- Columns to keep left/right of cursor
vim.o.fillchars = "eob: ,fold: ,foldopen:▾,foldsep: ,foldclose:▸"  -- Custom fill chars

---------------------------------------------------------------------------
-- Search
---------------------------------------------------------------------------
vim.o.hlsearch = false        -- Don't highlight search results
vim.o.ignorecase = true       -- Ignore case in search
vim.o.smartcase = true        -- Override ignorecase if uppercase used
vim.o.inccommand = "split"    -- Live preview of substitutions

---------------------------------------------------------------------------
-- Editing
---------------------------------------------------------------------------
vim.o.mouse = "a"             -- Enable mouse in all modes
vim.o.clipboard = "unnamedplus"  -- Use system clipboard
vim.o.breakindent = true      -- Indent wrapped lines
vim.o.smartindent = true      -- Smart autoindenting
vim.o.wrap = false            -- Don't wrap lines
vim.o.expandtab = true        -- Use spaces instead of tabs
vim.o.tabstop = 2             -- Tab width
vim.o.shiftwidth = 2          -- Indent width
vim.o.shiftround = true       -- Round indent to multiple of shiftwidth

---------------------------------------------------------------------------
-- Completion
---------------------------------------------------------------------------
vim.o.completeopt = "menu,menuone,noselect"  -- Completion options
vim.o.pumblend = 10           -- Popup menu transparency
vim.o.winblend = 10           -- Window transparency

---------------------------------------------------------------------------
-- Session
---------------------------------------------------------------------------
vim.opt.sessionoptions = { 
  "buffers", "curdir", "tabpages", "winsize", 
  "help", "globals", "skiprtp", "folds" 
}

---------------------------------------------------------------------------
-- Features
---------------------------------------------------------------------------
vim.g.have_nerd_font = true   -- Enable nerd font icons

---------------------------------------------------------------------------
-- Disable unused providers (performance)
---------------------------------------------------------------------------
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
