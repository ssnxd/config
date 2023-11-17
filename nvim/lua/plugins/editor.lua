return {
	-- Git related plugins
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',

	-- Detect tabstop and shiftwidth automatically
	'tpope/vim-sleuth',

	'jiangmiao/auto-pairs',
	'tpope/vim-surround',


	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local themes = require("telescope.themes")

			require('telescope').setup {
				defaults = vim.tbl_deep_extend("force", themes.get_dropdown(), {
					file_ignore_patterns = { ".git", "^node_modules", "target" },
					path_display = { "truncate" },
					selection_caret = "  ",
					mappings = {
						i = {
							['<C-u>'] = false,
							['<C-d>'] = false,
						},
					},
				}),

				extensions = {}
			}
			-- Enable telescope fzf native, if installed
			pcall(require('telescope').load_extension, 'fzf')


			vim.keymap.set('n', '<C-p>', require('telescope.builtin').git_files,
				{ desc = 'Search [G]it [F]iles' })
			vim.keymap.set('n', '<C-g>', require('telescope.builtin').find_files, { desc = 'Search [F]iles' })
			vim.keymap.set('n', '<C-s>', require('telescope.builtin').live_grep,
				{ desc = 'Search working dir' })
			-- vim.keymap.set('n', '<C-b>', ':Telescope file_browser path=%:p:h select_buffer=true<CR>', { desc = 'Open file explorer', noremap = true })
			vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers,
				{ desc = 'Search [B]uffer' })
		end,
	},

	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available. Make sure you have the system
	-- requirements installed.
	{
		'nvim-telescope/telescope-fzf-native.nvim',
		-- NOTE: If you are having trouble with this installation,
		--       refer to the README for telescope-fzf-native for more instructions.
		build = 'cmake',
		cond = function()
			return vim.fn.executable 'cmake' == 1
		end,
	},
	-- {
	-- 	"nvim-telescope/telescope-file-browser.nvim",
	-- 	dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
	-- },
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		config = function()
			require("nvim-tree").setup {
				renderer = {
					icons = {
						show = {
							file = false,
							folder = false,
							folder_arrow = true,
							git = false,
							modified = false,
							diagnostics = true,
							bookmarks = true,
						},
					},
					indent_markers = {
						enable = true,
						inline_arrows = false,
						icons = {
							corner = "└",
							edge = "│",
							item = "│",
							bottom = "─",
							none = " ",
						},
					},
				}
			}
			-- vim.keymap.set('n', '<C-b>', ':NvimTreeToggle <CR>', { desc = 'Open file explorer', noremap = true })
			vim.keymap.set('n', '<C-b>', ':NvimTreeFindFile <CR>',
				{ desc = 'Open file explorer with current file focus', noremap = true })
		end,

	},
	{
		-- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup {
				-- Add languages to be installed here that you want installed for treesitter
				ensure_installed = { 'go', 'lua', 'python', 'tsx', 'typescript', 'javascript', 'json',
					'yaml', 'vimdoc', 'vim' },

				-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
				auto_install = false,

				highlight = { enable = false },
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = '<c-space>',
						node_incremental = '<c-space>',
						scope_incremental = '<c-s>',
						node_decremental = '<M-space>',
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							['aa'] = '@parameter.outer',
							['ia'] = '@parameter.inner',
							['af'] = '@function.outer',
							['if'] = '@function.inner',
							['ac'] = '@class.outer',
							['ic'] = '@class.inner',
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							[']m'] = '@function.outer',
							[']]'] = '@class.outer',
						},
						goto_next_end = {
							[']M'] = '@function.outer',
							[']['] = '@class.outer',
						},
						goto_previous_start = {
							['[m'] = '@function.outer',
							['[['] = '@class.outer',
						},
						goto_previous_end = {
							['[M'] = '@function.outer',
							['[]'] = '@class.outer',
						},
					},
					swap = {
						enable = true,
						swap_next = {
							['<leader>a'] = '@parameter.inner',
						},
						swap_previous = {
							['<leader>A'] = '@parameter.inner',
						},
					},
				},
			}
		end,

	},
	{
		-- or
		{
			'akinsho/toggleterm.nvim',
			version = "*",
			opts = {
				open_mapping = [[<c-\>]],
			}
		}
	}
}
