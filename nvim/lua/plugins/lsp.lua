-- LSP, completion, formatting, and snippets configuration
-- Complete language server setup with modern tooling

return {
	---------------------------------------------------------------------------
	-- Mason (LSP servers & external tools manager)
	---------------------------------------------------------------------------
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls", -- Lua
					"ts_ls", -- TypeScript/JavaScript
					"jsonls", -- JSON
					"cssls", -- CSS
					"gopls", -- Go
					"html", -- HTML
				},
				automatic_installation = true,
			})
		end,
	},

	---------------------------------------------------------------------------
	-- Auto-install external formatters and linters
	---------------------------------------------------------------------------
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- Lua
					"stylua",
					-- Web Development
					"prettierd",
					"prettier",
					-- Go
					"gofumpt",
					"goimports",
				},
				run_on_start = true,
				start_delay = 0,
				debounce_hours = 12,
			})
		end,
	},

	---------------------------------------------------------------------------
	-- Code formatting (Conform.nvim)
	---------------------------------------------------------------------------
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>F",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = { "n", "v" },
				desc = "Format buffer / range",
			},
		},
		config = function()
			local conform = require("conform")
			local util = require("conform.util")

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					typescript = { "prettierd", "prettier", stop_after_first = true },
					javascriptreact = { "prettierd", "prettier", stop_after_first = true },
					typescriptreact = { "prettierd", "prettier", stop_after_first = true },
					json = { "prettierd", "prettier", stop_after_first = true },
					css = { "prettierd", "prettier", stop_after_first = true },
					scss = { "prettierd", "prettier", stop_after_first = true },
					html = { "prettierd", "prettier", stop_after_first = true },
					go = { "goimports", "gofumpt" },
				},
				format_on_save = function(bufnr)
					return {
						timeout_ms = 800,
						lsp_fallback = true,
						bufnr = bufnr,
					}
				end,
				notify_on_error = true,
				log_level = vim.log.levels.ERROR,
			})
		end,
	},

	---------------------------------------------------------------------------
	-- Snippets engine
	---------------------------------------------------------------------------
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},

	---------------------------------------------------------------------------
	-- Modern completion engine (blink.cmp)
	---------------------------------------------------------------------------
	{
		"saghen/blink.cmp",
		lazy = false,
		version = "v0.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		config = function()
			require("blink.cmp").setup({
				keymap = {
					preset = "default",
					["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
					["<C-e>"] = { "hide" },
					["<C-y>"] = { "select_and_accept" },
					["<C-p>"] = { "select_prev", "fallback" },
					["<C-n>"] = { "select_next", "fallback" },
					["<C-u>"] = { "scroll_documentation_up", "fallback" },
					["<C-d>"] = { "scroll_documentation_down", "fallback" },
				},
				appearance = {
					use_nvim_cmp_as_default = true,
					nerd_font_variant = "mono",
					kind_icons = {
						Text = "󰉿",
						Method = "󰊕",
						Function = "󰊕",
						Constructor = "󰒓",
						Field = "󰜢",
						Variable = "󰆦",
						Property = "󰖷",
						Class = "󱡠",
						Interface = "󱡠",
						Struct = "󱡠",
						Module = "󰅩",
						Unit = "󰪚",
						Value = "󰦨",
						Enum = "󰦨",
						EnumMember = "󰦨",
						Keyword = "󰻾",
						Constant = "󰏿",
						Snippet = "󱄽",
						Color = "󰏘",
						File = "󰈔",
						Reference = "󰬲",
						Folder = "󰉋",
						Event = "󱐋",
						Operator = "󰪚",
						TypeParameter = "󰬛",
					},
				},
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},
				cmdline = {
					sources = { "buffer", "cmdline" },
				},
				completion = {
					accept = {
						auto_brackets = { enabled = true },
					},
					menu = {
						draw = {
							treesitter = { "lsp" },
							columns = {
								{ "label", "label_description", gap = 1 },
								{ "kind_icon", "kind" },
							},
						},
					},
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 200,
					},
					ghost_text = { enabled = false },
				},
				signature = { enabled = true },
				snippets = {
					expand = function(snippet)
						require("luasnip").lsp_expand(snippet)
					end,
					active = function(filter)
						if filter and filter.direction then
							return require("luasnip").jumpable(filter.direction)
						end
						return require("luasnip").in_snippet()
					end,
					jump = function(dir)
						require("luasnip").jump(dir)
					end,
				},
			})
		end,
	},

	---------------------------------------------------------------------------
	-- JSON Schema store
	---------------------------------------------------------------------------
	{
		"b0o/schemastore.nvim",
		lazy = true,
	},

	---------------------------------------------------------------------------
	-- Core LSP configuration
	---------------------------------------------------------------------------
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
			"b0o/schemastore.nvim",
			"stevearc/conform.nvim",
			"ibhagwan/fzf-lua",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local cmp_caps = require("blink.cmp").get_lsp_capabilities()

			local function on_attach(client, bufnr)
				local fzf = require("fzf-lua")
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
				end

				-----------------------------------------------------------------------
				-- LSP Navigation (using fzf-lua for enhanced UX)
				-----------------------------------------------------------------------
				map("n", "gd", fzf.lsp_definitions, "Goto Definition")
				map("n", "gD", fzf.lsp_declarations, "Goto Declaration")
				map("n", "gi", fzf.lsp_implementations, "Goto Implementation")
				map("n", "gt", fzf.lsp_typedefs, "Goto Type Definition")
				map("n", "gr", fzf.lsp_references, "References")

				-----------------------------------------------------------------------
				-- Core LSP functionality
				-----------------------------------------------------------------------
				map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
				map("n", "<F2>", vim.lsp.buf.rename, "Rename Symbol")
				map({ "n", "v" }, "<leader>ca", fzf.lsp_code_actions, "Code Actions")

				-----------------------------------------------------------------------
				-- Diagnostics
				-----------------------------------------------------------------------
				map("n", "<leader>l", vim.diagnostic.open_float, "Show Line Diagnostics")
				map("n", "<leader>ld", fzf.diagnostics_document, "Document Diagnostics")
				map("n", "<leader>lw", fzf.diagnostics_workspace, "Workspace Diagnostics")
				map("n", "[d", function()
					vim.diagnostic.jump({ count = 1, float = true })
				end, "Previous Diagnostic")
				map("n", "]d", function()
					vim.diagnostic.jump({ count = -1, float = true })
				end, "Next Diagnostic")

				-----------------------------------------------------------------------
				-- Symbol navigation
				-----------------------------------------------------------------------
				map("n", "<leader>ds", fzf.lsp_document_symbols, "Document Symbols")
				map("n", "<leader>ws", fzf.lsp_workspace_symbols, "Workspace Symbols")
				map("n", "<leader>wS", fzf.lsp_live_workspace_symbols, "Live Workspace Symbols")

				-----------------------------------------------------------------------
				-- LSP Finder - unified view of definitions, references, etc.
				-----------------------------------------------------------------------
				map("n", "<leader>lf", fzf.lsp_finder, "LSP Finder (All Locations)")

				-----------------------------------------------------------------------
				-- Call hierarchy
				-----------------------------------------------------------------------
				map("n", "<leader>ci", fzf.lsp_incoming_calls, "Incoming Calls")
				map("n", "<leader>co", fzf.lsp_outgoing_calls, "Outgoing Calls")

				-----------------------------------------------------------------------
				-- Signature help (using Ctrl+s to avoid window nav conflict)
				-----------------------------------------------------------------------
				map({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, "Signature Help")
				map("n", "<leader>ls", vim.lsp.buf.signature_help, "Code Signatures")

				-----------------------------------------------------------------------
				-- Inlay hints toggle
				-----------------------------------------------------------------------
				if client.supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
					map("n", "<leader>th", function()
						local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
						vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
					end, "Toggle Inlay Hints")
				end
			end

			-----------------------------------------------------------------------
			-- Language server configurations
			-----------------------------------------------------------------------
			local servers = {
				-- Lua language server
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = { vim.env.VIMRUNTIME },
							},
							completion = { callSnippet = "Replace" },
							diagnostics = { globals = { "vim" } },
							hint = { enable = true },
						},
					},
				},

				-- TypeScript/JavaScript language server
				ts_ls = {
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},

				-- JSON language server with schema support
				jsonls = {
					settings = {
						json = {
							schemas = (function()
								local ok, schemastore = pcall(require, "schemastore")
								return ok and schemastore.json.schemas() or {}
							end)(),
							validate = { enable = true },
						},
					},
				},

				-- CSS language server
				cssls = {
					settings = {
						css = {
							validate = true,
							lint = { unknownAtRules = "ignore" },
						},
					},
				},

				-- Go language server
				gopls = {
					settings = {
						gopls = {
							analyses = { unusedparams = true },
							staticcheck = true,
							gofumpt = true,
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
						},
					},
				},

				-- HTML language server
				html = {
					settings = {
						html = {
							format = {
								templating = true,
								wrapLineLength = 120,
								wrapAttributes = "auto",
							},
							hover = {
								documentation = true,
								references = true,
							},
						},
					},
				},
			}

			-----------------------------------------------------------------------
			-- Apply server configurations
			-----------------------------------------------------------------------
			for name, cfg in pairs(servers) do
				cfg.capabilities = cmp_caps
				cfg.on_attach = on_attach
				lspconfig[name].setup(cfg)
			end

			-----------------------------------------------------------------------
			-- Diagnostics UI configuration
			-----------------------------------------------------------------------
			vim.diagnostic.config({
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✘",
						[vim.diagnostic.severity.WARN] = "▲",
						[vim.diagnostic.severity.HINT] = "⚑",
						[vim.diagnostic.severity.INFO] = "»",
					},
				},
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
			})
		end,
	},
}
