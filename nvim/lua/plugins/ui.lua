-- UI and visual enhancement plugins
-- Theme, statusline, indent guides, and interface improvements

return {
	---------------------------------------------------------------------------
	-- Theme
	---------------------------------------------------------------------------
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
			})

			vim.cmd.colorscheme("catppuccin-nvim")
		end,
	},

	---------------------------------------------------------------------------
	-- Icons (mini.icons also stands in for nvim-web-devicons)
	---------------------------------------------------------------------------
	{
		"echasnovski/mini.icons",
		lazy = true,
		opts = {},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},

	---------------------------------------------------------------------------
	-- Markdown rendering
	---------------------------------------------------------------------------
	{
		"OXY2DEV/markview.nvim",
		-- Do not lazy-load: the plugin is already lazy-loaded internally and
		-- must load after the colorscheme for correct highlight groups.
		lazy = false,
	},

	---------------------------------------------------------------------------
	-- Indent guides
	---------------------------------------------------------------------------
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = {
				char = "│",
				show_start = false,
				show_end = false,
				include = {
					node_type = {
						["*"] = { "*" },
					},
				},
			},
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		},
	},

	---------------------------------------------------------------------------
	-- Key binding hints
	---------------------------------------------------------------------------
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			delay = 180,
			win = {
				border = "single",
				padding = { 1, 2 },
				title = true,
				title_pos = "center",
			},
			layout = {
				width = { min = 22, max = 50 },
				spacing = 4,
			},
			icons = {
				breadcrumb = "»",
				separator = "→",
				group = "+",
				mappings = true,
				colors = true,
			},
			sort = { "local", "order", "group", "alphanum", "mod" },
		},
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
}
