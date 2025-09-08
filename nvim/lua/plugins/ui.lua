-- UI and visual enhancement plugins
-- Theme, statusline, indent guides, and interface improvements

return {
	---------------------------------------------------------------------------
	-- Color scheme (alternative themes commented out)
	---------------------------------------------------------------------------
	-- {
	--   "sainnhe/gruvbox-material",
	--   priority = 1000,
	--   config = function()
	--     vim.o.background = "dark"
	--     vim.g.gruvbox_material_background = "hard"
	--     vim.g.gruvbox_material_enable_italic = true
	--     -- vim.g.gruvbox_material_transparent_background = 1
	--     vim.g.gruvbox_material_dim_inactive_windows = 1
	--     vim.cmd.colorscheme("gruvbox-material")
	--   end,
	-- },

	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		lazy = false,
		priority = 1000,
		config = function()
			require("github-theme").setup({
				options = {
					transparent = false,
					hide_end_of_buffer = true,
					hide_nc_statusline = true,
					dim_inactive = true,
					styles = {
						comments = "italic",
						keywords = "bold",
						types = "italic,bold",
					},
				},
			})
			vim.cmd("colorscheme github_dark_default")
		end,
	},

	---------------------------------------------------------------------------
	-- Alternative tab bar (commented out)
	---------------------------------------------------------------------------
	-- {
	--   "nanozuki/tabby.nvim",
	--   -- event = 'VimEnter', -- if you want lazy load, see below
	--   dependencies = "nvim-tree/nvim-web-devicons",
	--   opts = {
	--     preset = "active_wins_at_tail",
	--     option = {
	--       nerdfont = true, -- whether use nerdfont
	--       lualine_theme = "gruvbox-material", -- lualine theme name
	--       section_separators = { left = "", right = "" }, -- separators for sections
	--     },
	--   },
	-- },

	---------------------------------------------------------------------------
	-- Statusline
	---------------------------------------------------------------------------
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "github_dark",
					icons_enabled = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = { "dashboard", "alpha", "starter" },
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = {
						{ "filename", path = 1 }, -- Show relative path
					},
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
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
}
