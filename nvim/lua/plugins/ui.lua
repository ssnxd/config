return {

	-- {
	-- 	"ellisonleao/gruvbox.nvim",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd.colorscheme 'gruvbox'
	-- 	end,
	-- },

	{ 
		"catppuccin/nvim", 
		name = "catppuccin", 
		priority = 1000, 
		config = function()
			require 'catppuccin'.setup {
				flavor = "mocha",
				transparent_background = true, -- disables setting the background color.
			}

			vim.cmd.colorscheme 'catppuccin-mocha'
		end,
	},

	{
		'nvim-tree/nvim-web-devicons',
		config = function()
			require 'nvim-web-devicons'.setup {
				-- globally enable different highlight colors per icon (default to true)
				-- if set to false all icons will have the default icon's color
				color_icons = true,
				-- globally enable default icons (default to false)
				-- will get overriden by `get_icons` option
				default = true,
				-- globally enable "strict" selection of icons - icon will be looked up in
				-- different tables, first by filename, and if not found by extension; this
				-- prevents cases when file doesn't have any extension but still gets some icon
				-- because its name happened to match some extension (default to false)
				strict = true,
			}
		end,
	},
	{
		'nvim-lualine/lualine.nvim',
		config = function()
			require 'lualine'.setup {
				options = {
					icons_enabled = false,
					component_separators = '|',
					section_separators = '',
					theme = 'catppuccin',
				},
				sections = {
					lualine_a = { 'mode' },
					lualine_b = { 'filename' },
					lualine_c = { 'branch' },
					lualine_x = {},
					lualine_y = { 'filetype' },
					lualine_z = { 'location' }
				},
				inactive_sections = {
					lualine_a = { 'filename' },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = { 'filetype' },
					lualine_z = { 'location' }
				},
			}
		end,
	},
	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		version = "2.20.8",
		opts = {
			show_current_context = true,
			show_trailing_blankline_indent = false,
		},
	},
	-- Normal mode
	-- "gcc" to line comment
	-- "gbc" to block comment
	-- Visual mode
	-- "gc" to line comment
	-- "gb" to block comment
	{ 'numToStr/Comment.nvim', opts = {
		---LHS of toggle mappings in NORMAL mode
		-- toggler = {
		-- 	---Line-comment toggle keymap
		-- 	line = '',
		-- 	---Block-comment toggle keymap
		-- 	block = 'gbc',
		-- },
	} },
}
