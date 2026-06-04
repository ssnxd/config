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

			local colors = {
				base = "#1e1e2e",
				blue = "#89b4fa",
				crust = "#11111b",
				flamingo = "#f2cdcd",
				green = "#a6e3a1",
				lavender = "#b4befe",
				mantle = "#181825",
				mauve = "#cba6f7",
				overlay0 = "#6c7086",
				overlay1 = "#7f849c",
				peach = "#fab387",
				red = "#f38ba8",
				sky = "#89dceb",
				surface0 = "#313244",
				surface1 = "#45475a",
				surface2 = "#585b70",
				teal = "#94e2d5",
				text = "#cdd6f4",
				yellow = "#f9e2af",
			}

			local set_hl = vim.api.nvim_set_hl

			local function apply_modern_ui_highlights()
				set_hl(0, "CursorLine", { bg = colors.surface0 })
				set_hl(0, "CursorLineNr", { fg = colors.peach, bold = true })
				set_hl(0, "LineNr", { fg = colors.overlay0 })
				set_hl(0, "WinSeparator", { fg = colors.surface2 })
				set_hl(0, "Visual", { bg = colors.surface1 })
				set_hl(0, "Search", { fg = colors.base, bg = colors.peach, bold = true })
				set_hl(0, "IncSearch", { fg = colors.base, bg = colors.red, bold = true })
				set_hl(0, "MatchParen", { fg = colors.blue, bg = colors.surface1, bold = true })

				set_hl(0, "NormalFloat", { fg = colors.text, bg = colors.mantle })
				set_hl(0, "FloatBorder", { fg = colors.blue, bg = colors.mantle })
				set_hl(0, "FloatTitle", { fg = colors.base, bg = colors.mauve, bold = true })

				set_hl(0, "Pmenu", { fg = colors.text, bg = colors.mantle })
				set_hl(0, "PmenuSel", { fg = colors.text, bg = colors.surface1, bold = true })
				set_hl(0, "PmenuKind", { fg = colors.mauve, bg = colors.mantle })
				set_hl(0, "PmenuExtra", { fg = colors.overlay1, bg = colors.mantle })
				set_hl(0, "PmenuSbar", { bg = colors.surface0 })
				set_hl(0, "PmenuThumb", { bg = colors.surface2 })

				set_hl(0, "DiagnosticVirtualTextError", { fg = colors.red, bg = colors.crust })
				set_hl(0, "DiagnosticVirtualTextWarn", { fg = colors.yellow, bg = colors.crust })
				set_hl(0, "DiagnosticVirtualTextInfo", { fg = colors.sky, bg = colors.crust })
				set_hl(0, "DiagnosticVirtualTextHint", { fg = colors.teal, bg = colors.crust })
				set_hl(0, "LspReferenceText", { bg = colors.surface0 })
				set_hl(0, "LspReferenceRead", { bg = colors.surface0 })
				set_hl(0, "LspReferenceWrite", { bg = colors.surface1, underline = true })

				set_hl(0, "FzfLuaNormal", { fg = colors.text, bg = colors.mantle })
				set_hl(0, "FzfLuaBorder", { fg = colors.blue, bg = colors.mantle })
				set_hl(0, "FzfLuaTitle", { fg = colors.base, bg = colors.mauve, bold = true })
				set_hl(0, "FzfLuaPreviewNormal", { fg = colors.text, bg = colors.mantle })
				set_hl(0, "FzfLuaPreviewBorder", { fg = colors.surface2, bg = colors.mantle })
				set_hl(0, "FzfLuaPreviewTitle", { fg = colors.green, bg = colors.mantle, bold = true })
				set_hl(0, "FzfLuaCursorLine", { fg = colors.text, bg = colors.surface1, bold = true })
				set_hl(0, "FzfLuaFzfCursorLine", { fg = colors.text, bg = colors.surface1, bold = true })
				set_hl(0, "FzfLuaFzfMatch", { fg = colors.peach, bold = true })
				set_hl(0, "FzfLuaFzfPrompt", { fg = colors.mauve, bold = true })
				set_hl(0, "FzfLuaFzfPointer", { fg = colors.red, bold = true })
				set_hl(0, "FzfLuaFzfMarker", { fg = colors.red, bold = true })
				set_hl(0, "FzfLuaFzfSpinner", { fg = colors.mauve, bold = true })
				set_hl(0, "FzfLuaFzfInfo", { fg = colors.overlay1 })
				set_hl(0, "FzfLuaFzfSeparator", { fg = colors.surface2 })
				set_hl(0, "FzfLuaFzfGutter", { bg = colors.mantle })
				set_hl(0, "FzfLuaHeaderBind", { fg = colors.peach, bold = true })
				set_hl(0, "FzfLuaHeaderText", { fg = colors.overlay1 })
				set_hl(0, "FzfLuaPathLineNr", { fg = colors.green, bold = true })
				set_hl(0, "FzfLuaPathColNr", { fg = colors.sky })
				set_hl(0, "FzfLuaBufName", { fg = colors.blue, bold = true })
				set_hl(0, "FzfLuaBufNr", { fg = colors.peach })
				set_hl(0, "FzfLuaDirIcon", { fg = colors.blue })
				set_hl(0, "FzfLuaDirPart", { fg = colors.overlay0 })
				set_hl(0, "FzfLuaFilePart", { fg = colors.text, bold = true })
				set_hl(0, "FzfLuaSearch", { fg = colors.base, bg = colors.peach, bold = true })

				set_hl(0, "WhichKeyNormal", { fg = colors.text, bg = colors.mantle })
				set_hl(0, "WhichKeyBorder", { fg = colors.blue, bg = colors.mantle })
				set_hl(0, "WhichKeyTitle", { fg = colors.mauve, bg = colors.mantle, bold = true })
				set_hl(0, "WhichKey", { fg = colors.peach, bold = true })
				set_hl(0, "WhichKeyGroup", { fg = colors.mauve, bold = true })
				set_hl(0, "WhichKeyDesc", { fg = colors.text })
				set_hl(0, "WhichKeySeparator", { fg = colors.overlay0 })
				set_hl(0, "WhichKeyValue", { fg = colors.green })

				set_hl(0, "NoiceCmdlinePopupBorder", { fg = colors.blue })
				set_hl(0, "NoiceCmdlinePopupBorderSearch", { fg = colors.peach })
				set_hl(0, "NoiceCmdlineIcon", { fg = colors.mauve, bold = true })
				set_hl(0, "NoiceCmdlinePrompt", { fg = colors.mauve, bold = true })
				set_hl(0, "NoicePopupBorder", { fg = colors.blue })
				set_hl(0, "NoiceSplitBorder", { fg = colors.blue })
				set_hl(0, "NoiceConfirmBorder", { fg = colors.peach })
				set_hl(0, "NoicePopupmenu", { fg = colors.text, bg = colors.mantle })
				set_hl(0, "NoicePopupmenuBorder", { fg = colors.blue, bg = colors.mantle })
				set_hl(0, "NoicePopupmenuSelected", { fg = colors.text, bg = colors.surface1, bold = true })
				set_hl(0, "NoicePopupmenuMatch", { fg = colors.peach, bold = true })
				set_hl(0, "NoiceMini", { fg = colors.overlay1, bg = colors.mantle })
				set_hl(0, "NoiceFormatProgressDone", { fg = colors.green, bold = true })
				set_hl(0, "NoiceFormatProgressTodo", { fg = colors.overlay0 })

				set_hl(0, "OilDir", { fg = colors.blue, bold = true })
				set_hl(0, "OilDirHidden", { fg = colors.surface2, italic = true })
				set_hl(0, "OilDirIcon", { fg = colors.blue })
				set_hl(0, "OilFile", { fg = colors.text })
				set_hl(0, "OilFileHidden", { fg = colors.overlay0, italic = true })
				set_hl(0, "OilHidden", { fg = colors.overlay0, italic = true })
				set_hl(0, "OilLink", { fg = colors.mauve })
				set_hl(0, "OilLinkTarget", { fg = colors.overlay1 })
				set_hl(0, "OilOrphanLink", { fg = colors.red, bold = true })
				set_hl(0, "OilOrphanLinkTarget", { fg = colors.red })
				set_hl(0, "OilPermissionRead", { fg = colors.green })
				set_hl(0, "OilPermissionWrite", { fg = colors.yellow })
				set_hl(0, "OilPermissionExecute", { fg = colors.red })
				set_hl(0, "OilSize", { fg = colors.sky })
				set_hl(0, "OilMtime", { fg = colors.overlay1 })
				set_hl(0, "OilCreate", { fg = colors.green })
				set_hl(0, "OilDelete", { fg = colors.red })
				set_hl(0, "OilMove", { fg = colors.peach })
				set_hl(0, "OilCopy", { fg = colors.sky })
				set_hl(0, "OilChange", { fg = colors.yellow })
				set_hl(0, "OilRestore", { fg = colors.green })
				set_hl(0, "OilPurge", { fg = colors.red, bold = true })
				set_hl(0, "OilTrash", { fg = colors.red })
				set_hl(0, "OilTrashSourcePath", { fg = colors.overlay1 })
				set_hl(0, "OilEmpty", { fg = colors.overlay0 })
				set_hl(0, "OilSocket", { fg = colors.flamingo })

				set_hl(0, "FidgetNormal", { fg = colors.text, bg = colors.mantle })
				set_hl(0, "FidgetBorder", { fg = colors.blue, bg = colors.mantle })
				set_hl(0, "FidgetTitle", { fg = colors.base, bg = colors.mauve, bold = true })
				set_hl(0, "FidgetTask", { fg = colors.peach, bold = true })
				set_hl(0, "FidgetDone", { fg = colors.green, bold = true })
				set_hl(0, "FidgetGroup", { fg = colors.mauve, bold = true })
				set_hl(0, "FidgetIcon", { fg = colors.sky, bold = true })
				set_hl(0, "FidgetInfo", { fg = colors.sky })
				set_hl(0, "FidgetWarn", { fg = colors.yellow })
				set_hl(0, "FidgetError", { fg = colors.red })
				set_hl(0, "FidgetMuted", { fg = colors.overlay1 })
			end

			apply_modern_ui_highlights()
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "catppuccin*",
				callback = apply_modern_ui_highlights,
			})
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
		opts = {
			preset = "modern",
			delay = 180,
			win = {
				border = "single",
				padding = { 1, 2 },
				title = true,
				title_pos = "center",
				wo = {
					winblend = 0,
				},
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
