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
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local themes = require("telescope.themes")

			require("telescope").setup({
				defaults = vim.tbl_deep_extend("force", themes.get_dropdown(), {
					file_ignore_patterns = { ".git", "^node_modules", "target" },
					path_display = { "truncate" },
					selection_caret = "  ",
					mappings = {
						i = {
							["<C-u>"] = false,
							["<C-d>"] = false,
						},
					},
				}),

				extensions = {},
			})
			-- Enable telescope fzf native, if installed
			pcall(require("telescope").load_extension, "fzf")

			local builtin = require("telescope.builtin")

			local function neoclip()
				vim.cmd([[:Telescope neoclip]])
			end

			vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Search [G]it [F]iles" })
			vim.keymap.set("n", "<C-g>", builtin.find_files, { desc = "Search [F]iles" })
			vim.keymap.set("n", "<C-s>", builtin.live_grep, { desc = "Search working dir" })
			vim.keymap.set("n", "<C-r>", builtin.resume, { desc = "Resume search" })
			vim.keymap.set("n", "<leader>cb", neoclip, { desc = "Search clipboard" })
		end,
	},

	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available. Make sure you have the system
	-- requirements installed.
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		-- NOTE: If you are having trouble with this installation,
		--       refer to the README for telescope-fzf-native for more instructions.
		build = "make",
	},
	{
		"AckslD/nvim-neoclip.lua",
		dependencies = {
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("neoclip").setup()
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

				-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
				auto_install = false,

				highlight = { enable = false },
				indent = { enable = true },
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
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			open_mapping = [[<c-\>]],
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		version = "*",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"nanozuki/tabby.nvim",
		-- event = 'VimEnter', -- if you want lazy load, see below
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {},
	},
}
