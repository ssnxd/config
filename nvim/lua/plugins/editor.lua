return {
	-- Git related plugins
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",

	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
	"tpope/vim-surround",

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},

	{
		"windwp/nvim-ts-autotag",
		event = "BufReadPre",
		config = true,
		opts = {},
	},
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("fzf-lua").setup({
				"hide",
			})

			-- Buffers
			vim.api.nvim_set_keymap(
				"n",
				"<C-\\>",
				"<cmd>lua require('fzf-lua').buffers()<CR>",
				{ noremap = true, silent = true }
			)

			-- files
			vim.api.nvim_set_keymap(
				"n",
				"<C-p>",
				"<cmd>lua require('fzf-lua').files()<CR>",
				{ noremap = true, silent = true }
			)

			-- grep
			vim.api.nvim_set_keymap(
				"n",
				"<C-G>",
				"<cmd>lua require('fzf-lua').grep()<CR>",
				{ noremap = true, silent = true }
			)

			-- live grep
			vim.api.nvim_set_keymap(
				"n",
				"<C-g>",
				"<cmd>lua require('fzf-lua').live_grep()<CR>",
				{ noremap = true, silent = true }
			)

			-- symbols
			vim.api.nvim_set_keymap(
				"n",
				"<C-m>",
				"<cmd>lua require('fzf-lua').marks()<CR>",
				{ noremap = true, silent = true }
			)

			-- builtin
			-- vim.api.nvim_set_keymap(
			-- 	"n",
			-- 	"<C-k>",
			-- 	"<cmd>lua require('fzf-lua').builtin()<CR>",
			-- 	{ noremap = true, silent = true }
			-- )
		end,
	},
	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- Add languages to be installed here that you want installed for treesitter
				ensure_installed = {
					"go",
					"lua",
					"python",
					"tsx",
					"typescript",
					"javascript",
					"json",
					"yaml",
					"vimdoc",
					"vim",
				},

				cc = "zig", -- The C/C++ compiler to use for C/C++ files

				-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
				auto_install = false,

				highlight = { enable = true },
				indent = { enable = false },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<c-space>",
						node_incremental = "<c-space>",
						scope_incremental = "<c-s>",
						node_decremental = "<M-space>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},
	{
		"stevearc/aerial.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		lazy = false,
	},
	{
		"lewis6991/gitsigns.nvim",
		version = "*",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"numToStr/Comment.nvim",
		opts = {},
	},
}
