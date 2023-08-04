return {
	{
		'gruvbox-community/gruvbox',
		priority = 1000,
		config = function()
			vim.cmd.colorscheme 'gruvbox'
			vim.g.gruvbox_contrast_dark = 'hard'
			vim.g.gruvbox_contrast_light = 'soft'
			vim.g.gruvbox_sign_column = 'bg0'
			vim.g.gruvbox_italic = 1
			vim.o.background = 'dark'
		end,
	},

	{
		'nvim-tree/nvim-web-devicons',
		priority = 1000,
		config = function()
			require'nvim-web-devicons'.setup {
				-- globally enable different highlight colors per icon (default to true)
				-- if set to false all icons will have the default icon's color
				color_icons = true;
				-- globally enable default icons (default to false)
				-- will get overriden by `get_icons` option
				default = true;
				-- globally enable "strict" selection of icons - icon will be looked up in
				-- different tables, first by filename, and if not found by extension; this
				-- prevents cases when file doesn't have any extension but still gets some icon
				-- because its name happened to match some extension (default to false)
				strict = true;
			}
		end,
	},
	{
		-- Set lualine as statusline
		'vim-airline/vim-airline',
		config = function()
			vim.cmd([[
				let g:airline#extensions#tabline#enabled = 1
				let g:airline_powerline_fonts = 1
			]])
		end,
	},

	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help indent_blankline.txt`
		opts = {
			char = '┊',
			show_trailing_blankline_indent = false,
		},
	},

	-- "gc" to comment visual regions/lines
	{ 'numToStr/Comment.nvim', opts = {} },
}
