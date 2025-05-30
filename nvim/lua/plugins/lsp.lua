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
			"zbirenbaum/copilot.lua",
			"fang2hou/blink-copilot",
		},

		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }

					-- Go To commands
					-- Go to Definition
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

					-- Go to References
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

					-- Go to Implementation
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

					-- Go to Type Definition
					vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, opts)

					-- Go to Declaration
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

					-- Find all references
					vim.keymap.set("n", "<leader>fr", vim.lsp.buf.references, opts)

					-- Peek Definition (Alt+F12 in VSCode)
					-- This requires a floating window implementation
					-- We'll provide a simple one below
					vim.keymap.set("n", "<leader>pd", function()
						-- Open definition in a floating window
						local params = vim.lsp.util.make_position_params()
						vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result, _, _)
							if result and result[1] then
								vim.lsp.util.preview_location(result[1])
							end
						end)
					end, opts)

					-- Additional useful LSP commands
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

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

			-- Copilot
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})

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

			-- AI code completion
			require("codecompanion").setup({
				adapters = {
					copilot = function()
						return require("codecompanion.adapters").extend("copilot", {
							schema = {
								model = {
									default = "gpt-4.1",
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
							components = {
								kind_icon = {
									text = function(ctx)
										-- Check if the completion is from Copilot
										if ctx.source_name == "copilot" then
											return "" -- GitHub icon from Nerd Fonts
										else
											-- Default behavior for LSP and other sources
											local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
											return kind_icon
										end
									end,
									-- (optional) use highlights from mini.icons
									highlight = function(ctx)
										local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
										return hl
									end,
								},
								kind = {
									-- (optional) use highlights from mini.icons
									highlight = function(ctx)
										local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
										return hl
									end,
								},
							},
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
					default = { "lsp", "path", "snippets", "buffer", "copilot" },
					per_filetype = { "codecompanion" },
					providers = {
						copilot = {
							name = "copilot",
							module = "blink-copilot",
							score_offset = 100,
							async = true,
						},
					},
				},
				cmdline = {
					enabled = true,
					sources = {
						"cmdline",
						"path",
					},
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
	},
}
