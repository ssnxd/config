local ensure_installed = {
	"lua_ls",
	"ts_ls",
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
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-vsnip" },
			{ "hrsh7th/vim-vsnip" },
			{ "rafamadriz/friendly-snippets" },
			{ "stevearc/conform.nvim" },
			{ "onsails/lspkind.nvim" },
		},
		config = function()
			-- note: diagnostics are not exclusive to lsp servers
			-- so these can be global keybindings
			vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")
			vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
			vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }

					-- these will be buffer-local keybindings
					-- because they only work if you have an active language server

					vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
					vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
					vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
					vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
					vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
					vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
					vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)

					-- Code actions
					vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

					-- Rename
					vim.keymap.set("n", "<F3>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
				end,
			})

			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					-- Enter key confirms completion item
					["<CR>"] = cmp.mapping.confirm({ select = false }),

					-- Ctrl + space triggers completion menu
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "vsnip" },
				}, {
					{ name = "buffer" },
				}),
			})

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})

			local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

			local default_setup = function(server)
				require("lspconfig")[server].setup({
					capabilities = lsp_capabilities,
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
				format_on_save = {
					-- These options will be passed to conform.format()
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})

			require("lspkind").init()
		end,
	},
}
