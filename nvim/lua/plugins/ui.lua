return {

	{
		"dracula/vim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("dracula")
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		config = function()
			local function task_name()
				return vim.g.CURRENT_TASK_NAME
			end

			require("lualine").setup({
				options = {
					icons_enabled = true,
					component_separators = "",
					section_separators = { left = "", right = "" },
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
	-- Normal mode
	-- "gcc" to line comment
	-- "gbc" to block comment
	-- Visual mode
	-- "gc" to line comment
	-- "gb" to block comment
	{
		"numToStr/Comment.nvim",
		opts = {
			---LHS of toggle mappings in NORMAL mode
			-- toggler = {
			-- 	---Line-comment toggle keymap
			-- 	line = '',
			-- 	---Block-comment toggle keymap
			-- 	block = 'gbc',
			-- },
		},
	},

	{
		"nanozuki/tabby.nvim",
		-- event = 'VimEnter', -- if you want lazy load, see below
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			preset = "active_wins_at_tail",
			option = {
				nerdfont = true, -- whether use nerdfont
				lualine_theme = "dracula", -- lualine theme name
			},
		},
	},
}
