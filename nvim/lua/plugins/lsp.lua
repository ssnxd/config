return {
	{

		"neoclide/coc.nvim",
		branch = "master",
		build = "yarn install --frozen-lockfile",
		config = function()
			-- auto load
			vim.g.coc_global_extensions = { 'coc-tsserver', 'coc-json', 'coc-css', 'coc-snippets',
				'coc-prettier' }

			local keyset = vim.keymap.set

			-- Autocomplete
			function _G.check_back_space()
				local col = vim.fn.col('.') - 1
				return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
			end

			-- Use Tab for trigger completion with characters ahead and navigate
			-- NOTE: There's always a completion item selected by default, you may want to enable
			-- no select by setting `"suggest.noselect": true` in your configuration file
			-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
			-- other plugins before putting this into your config
			local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
			keyset("i", "<TAB>",
				'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
				opts)
			keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

			-- Make <CR> to accept selected completion item or notify coc.nvim to format
			keyset("i", "<cr>",
				[[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
				opts)

			-- Use <c-j> to trigger snippets
			keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")

			-- Use `[g` and `]g` to navigate diagnostics
			-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
			keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
			keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

			-- GoTo code navigation
			keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
			keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
			keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
			keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

			-- Symbol renaming
			keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

			-- Use K to show documentation in preview window
			function _G.show_docs()
				local cw = vim.fn.expand('<cword>')
				if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
					vim.api.nvim_command('h ' .. cw)
				elseif vim.api.nvim_eval('coc#rpc#ready()') then
					vim.fn.CocActionAsync('doHover')
				else
					vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
				end
			end

			keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', { silent = true })

			local opts = { silent = true, nowait = true }
			keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
			keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

			-- Remap keys for apply code actions at the cursor position.
			keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
			-- Remap keys for apply source code actions for current file.
			keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
			-- Apply the most preferred quickfix action on the current line.
			keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

			-- " Add `:Prettier` command to fold current buffer
			vim.api.nvim_create_user_command("Prettier ", ":CocCommand prettier.forceFormatDocument", { nargs = 0 })

			-- " Add `:Fold` command to fold current buffer
			vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", { nargs = '?' })

			-- Add `:OR` command for organize imports of the current buffer
			vim.api.nvim_create_user_command("OR",
				"call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})
		end,

	}

	-- {
	-- 	-- LSP Configuration & Plugins
	-- 	'neovim/nvim-lspconfig',
	--
	-- 	dependencies = {
	-- 		-- Improves the Neovim built-in LSP experience.
	-- 		'nvimdev/lspsaga.nvim',
	--
	-- 		-- Automatically install LSPs to stdpath for neovim
	-- 		'williamboman/mason.nvim',
	-- 		'williamboman/mason-lspconfig.nvim',
	--
	-- 		-- Useful status updates for LSP
	-- 		{ 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
	--
	-- 		-- Additional lua configuration, makes nvim stuff amazing!
	-- 		'folke/neodev.nvim',
	--
	-- 		-- completion
	-- 		'hrsh7th/nvim-cmp',
	--
	-- 		-- Snippet Engine & its associated nvim-cmp source
	-- 		'L3MON4D3/LuaSnip',
	-- 		'saadparwaiz1/cmp_luasnip',
	--
	-- 		-- Adds LSP completion capabilities
	-- 		'hrsh7th/cmp-nvim-lsp',
	--
	-- 		-- Adds a number of user-friendly snippets
	-- 		'rafamadriz/friendly-snippets',
	--
	-- 		-- :SymbolsOutline
	-- 		"simrat39/symbols-outline.nvim",
	--
	-- 	},
	--
	-- 	config = function()
	-- 		-- [[ Configure LSP ]]
	-- 		-- Enable the following language servers
	-- 		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
	-- 		--  Add any additional override configuration in the following tables. They will be passed to
	-- 		--  the `settings` field of the server config. You must look up that documentation yourself.
	-- 		--  If you want to override the default filetypes that your language server will attach to you can
	-- 		--  define the property 'filetypes' to the map in question.
	--
	-- 		local servers = {
	-- 			-- clangd = {},
	-- 			gopls = {},
	-- 			-- pyright = {},
	-- 			-- rust_analyzer = {},
	-- 			tsserver = {
	-- 				-- single_file_support = false,
	-- 				-- root_dir = nvim_lsp.util.root_pattern("package.json"),
	-- 			},
	-- 			-- denols = {
	-- 			-- 	root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
	-- 			-- },
	-- 			html = { filetypes = { 'html', 'twig', 'hbs' } },
	--
	-- 			lua_ls = {
	-- 				Lua = {
	-- 					workspace = { checkThirdParty = false },
	-- 					telemetry = { enable = false },
	-- 				},
	-- 			},
	-- 		}
	--
	--
	-- 		--  This function gets run when an LSP connects to a particular buffer.
	-- 		local on_attach = function(_, bufnr)
	-- 			-- In this case, we create a function that lets us more easily define mappings specific
	-- 			-- for LSP related items. It sets the mode, buffer and description for us each time.
	-- 			local nmap = function(keys, func, desc)
	-- 				if desc then
	-- 					desc = 'LSP: ' .. desc
	-- 				end
	--
	-- 				vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	-- 			end
	--
	-- 			nmap('<F2>', vim.lsp.buf.rename, '[R]e[n]ame')
	-- 			nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
	-- 			nmap('<leader>f', vim.lsp.buf.format, '[F]ormat [D]ocument')
	--
	-- 			nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
	-- 			nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
	-- 			nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
	-- 			nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	--
	-- 			nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
	-- 			nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols,
	-- 				'[D]ocument [S]ymbols')
	--
	--
	-- 			-- Create a command `:Format` local to the LSP buffer
	-- 			vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
	-- 				vim.lsp.buf.format()
	-- 			end, { desc = 'Format current buffer with LSP' })
	--
	-- 			-- Create a command `:Format` local to the LSP buffer
	-- 			vim.api.nvim_buf_create_user_command(bufnr, 'OR', function(_)
	-- 				vim.lsp.buf.execute_command({
	-- 					command = "_typescript.organizeImports",
	-- 					arguments = { vim.fn.expand("%:p") }
	-- 				})
	-- 			end, { desc = 'organize imports on current buffer' })
	-- 		end
	--
	--
	--
	--
	-- 		-- [[ Configure cmp ]]
	-- 		local cmp = require 'cmp'
	-- 		local luasnip = require 'luasnip'
	-- 		require('luasnip.loaders.from_vscode').lazy_load()
	--
	--
	-- 		luasnip.config.setup {}
	--
	-- 		cmp.setup {
	-- 			snippet = {
	-- 				expand = function(args)
	-- 					luasnip.lsp_expand(args.body)
	-- 				end,
	-- 			},
	-- 			mapping = cmp.mapping.preset.insert {
	-- 				['<C-n>'] = cmp.mapping.select_next_item(),
	-- 				['<C-p>'] = cmp.mapping.select_prev_item(),
	-- 				['<C-d>'] = cmp.mapping.scroll_docs(-4),
	-- 				['<C-f>'] = cmp.mapping.scroll_docs(4),
	-- 				['<C-Space>'] = cmp.mapping.complete {},
	-- 				['<CR>'] = cmp.mapping.confirm {
	-- 					behavior = cmp.ConfirmBehavior.Replace,
	-- 					select = true,
	-- 				},
	-- 				['<Tab>'] = cmp.mapping(function(fallback)
	-- 					if cmp.visible() then
	-- 						cmp.select_next_item()
	-- 					elseif luasnip.expand_or_locally_jumpable() then
	-- 						luasnip.expand_or_jump()
	-- 					else
	-- 						fallback()
	-- 					end
	-- 				end, { 'i', 's' }),
	-- 				['<S-Tab>'] = cmp.mapping(function(fallback)
	-- 					if cmp.visible() then
	-- 						cmp.select_prev_item()
	-- 					elseif luasnip.locally_jumpable(-1) then
	-- 						luasnip.jump(-1)
	-- 					else
	-- 						fallback()
	-- 					end
	-- 				end, { 'i', 's' }),
	-- 			},
	-- 			sources = {
	-- 				{ name = 'nvim_lsp' },
	-- 				{ name = 'luasnip' },
	-- 			},
	-- 		}
	--
	--
	-- 		-- [[ Configure mason ]]
	-- 		-- mason-lspconfig requires that these setup functions are called in this order
	-- 		-- before setting up the servers.
	-- 		require('mason').setup()
	-- 		require('mason-lspconfig').setup()
	-- 		-- Ensure the servers above are installed
	-- 		local mason_lspconfig = require 'mason-lspconfig'
	--
	-- 		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
	-- 		local capabilities = vim.lsp.protocol.make_client_capabilities()
	-- 		capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
	--
	-- 		mason_lspconfig.setup {
	-- 			ensure_installed = vim.tbl_keys(servers),
	-- 		}
	--
	-- 		mason_lspconfig.setup_handlers {
	-- 			function(server_name)
	-- 				require('lspconfig')[server_name].setup {
	-- 					capabilities = capabilities,
	-- 					on_attach = on_attach,
	-- 					settings = servers[server_name],
	-- 					filetypes = (servers[server_name] or {}).filetypes,
	-- 				}
	-- 			end,
	-- 		}
	--
	-- 		-- Setup neovim lua configuration
	-- 		require('neodev').setup()
	--
	--
	-- 		require("symbols-outline").setup()
	-- 		vim.keymap.set("n", "<leader>ss", ":SymbolsOutline<CR>", { desc = "Open symbols", remap = true })
	--
	-- 		require('lspsaga').setup({})
	-- 	end,
	--
	--
	-- },
}
