local ensure_installed = {
	"lua_ls",
	"ts_ls",
	"angularls",
	"gopls",
	"biome",
	"html",
	"cssls",
	"tailwindcss",
	"jsonls",
}

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {

			-- completion engine
			{ "saghen/blink.cmp", version = "1.*", opts_extend = { "sources.default" } },
			"rafamadriz/friendly-snippets",

			-- auto manage lsp servers
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			-- Formater
			"stevearc/conform.nvim",

			-- AI code completion
			{
				"olimorris/codecompanion.nvim",
				dependencies = {
					"nvim-lua/plenary.nvim",
					"nvim-treesitter/nvim-treesitter",
				},
			},


			"j-hui/fidget.nvim",
			"zbirenbaum/copilot.lua",
		},

		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }

					-- these will be buffer-local keybindings
					-- because they only work if you have an active language server

					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gS", vim.lsp.buf.signature_help, opts)

					-- Code actions
					vim.keymap.set("n", "<F2>", vim.lsp.buf.code_action, opts)

					-- Rename
					vim.keymap.set("n", "<F3>", vim.lsp.buf.rename, opts)

					-- Diagnostic navigation
					vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				end,
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local default_setup = function(server)
				require("lspconfig")[server].setup({
					capabilities = capabilities,
				})
			end

			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = ensure_installed,
				automatic_installation = true,
				handlers = {
					default_setup,
				},
			})

			-- Formaters
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "biome-check" },
					javascriptreact = { "biome-check" },
					typescript = { "biome-check" },
					typescriptreact = { "biome-check" },
					json = { "biome-check" },
				},
				--[[ format_on_save = {
					-- These options will be passed to conform.format()
					timeout_ms = 500,
					lsp_format = "fallback",
				}, ]]
			})

			-- Create explicit formatting command
			vim.api.nvim_create_user_command("Format", function()
				require("conform").format({ async = true })
			end, {})


			-- Copilot
			require("copilot").setup({})


			-- AI code completion
			require("codecompanion").setup({
				adapters = {
					copilot = function()
						return require("codecompanion.adapters").extend("copilot", {
							schema = {
								model = {
									default = "claude-3.7-sonnet",
								},
							},
						})
					end,
				},
			})

			-- Blink
			require("blink.cmp").setup({
				keymap = { preset = "default" },
				appearance = {
					nerd_font_variant = "mono",
				},

				completion = {
					accept = {
						-- experimental auto-brackets support
						auto_brackets = {
							enabled = true,
						},
					},
					menu = {
						draw = {
							treesitter = { "lsp" },
						},
					},
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 200,
					},
					ghost_text = {
						enabled = vim.g.ai_cmp,
					},
				},

				-- Default list of enabled providers defined so that you can extend it
				-- elsewhere in your config, without redefining it, due to `opts_extend`
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
					per_filetype = { "codecompanion" },
				},
				cmdline = {
					enabled = false,
				},

				-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
				-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
				-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
				--
				-- See the fuzzy documentation for more information
				fuzzy = { implementation = "prefer_rust_with_warning" },
				signature = { enabled = true },
			})
		end,

	}
}
