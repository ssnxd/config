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
	-- Statusline
	---------------------------------------------------------------------------
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local colors = {
				bg = "#1e1e2e",
				fg = "#cdd6f4",
				blue = "#89b4fa",
				cyan = "#89dceb",
				green = "#a6e3a1",
				orange = "#fab387",
				red = "#f38ba8",
				mauve = "#cba6f7",
				muted = "#7f849c",
				surface = "#313244",
			}

			local theme = {
				normal = {
					a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
					b = { fg = colors.fg, bg = colors.surface },
					c = { fg = colors.fg, bg = colors.bg },
				},
				insert = { a = { fg = colors.bg, bg = colors.green, gui = "bold" } },
				visual = { a = { fg = colors.bg, bg = colors.orange, gui = "bold" } },
				replace = { a = { fg = colors.bg, bg = colors.red, gui = "bold" } },
				command = { a = { fg = colors.bg, bg = colors.mauve, gui = "bold" } },
				inactive = {
					a = { fg = colors.muted, bg = colors.bg },
					b = { fg = colors.muted, bg = colors.bg },
					c = { fg = colors.muted, bg = colors.bg },
				},
			}

			require("lualine").setup({
				options = {
					theme = theme,
					icons_enabled = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					globalstatus = true,
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
					lualine_x = { "filetype" },
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
