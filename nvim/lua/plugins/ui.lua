return {
	{
		"sainnhe/gruvbox-material",
		priority = 1000,
		config = function()
			vim.o.background = "dark"

			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_enable_italic = true
			-- vim.g.gruvbox_material_transparent_background = 1
			vim.g.gruvbox_material_dim_inactive_windows = 1
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		"nanozuki/tabby.nvim",
		-- event = 'VimEnter', -- if you want lazy load, see below
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			preset = "active_wins_at_tail",
			option = {
				nerdfont = true, -- whether use nerdfont
				lualine_theme = "gruvbox-material", -- lualine theme name
				section_separators = { left = "", right = "" }, -- separators for sections
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			local function task_name()
				return vim.g.CURRENT_TASK_NAME
			end

			require("lualine").setup({
				options = {
					theme = "gruvbox-material",
					icons_enabled = true,
					component_separators = "",
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "filename" },
					lualine_c = { "branch" },
					lualine_x = { task_name },
					lualine_y = { "filetype" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = { "filename" },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = { "filetype" },
					lualine_z = { "location" },
				},
			})
		end,
	},
	{
		-- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
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
}
