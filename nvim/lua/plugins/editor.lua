-- Editor enhancement plugins
-- File navigation, text manipulation, git integration, and developer tools

return {
  ---------------------------------------------------------------------------
  -- Git integration
  ---------------------------------------------------------------------------
  "tpope/vim-fugitive",      -- Git commands in vim
  "tpope/vim-rhubarb",       -- GitHub integration for fugitive

  ---------------------------------------------------------------------------
  -- Text manipulation
  ---------------------------------------------------------------------------
  "tpope/vim-surround",      -- Surround text with quotes, brackets, etc.

  ---------------------------------------------------------------------------
  -- Smart indentation detection
  ---------------------------------------------------------------------------
  "NMAC427/guess-indent.nvim", -- Auto-detect tabstop and shiftwidth

  ---------------------------------------------------------------------------
  -- Auto-pairing
  ---------------------------------------------------------------------------
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  ---------------------------------------------------------------------------
  -- Auto-close HTML/XML tags
  ---------------------------------------------------------------------------
  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPre",
    config = true,
    opts = {},
  },

  ---------------------------------------------------------------------------
  -- Fuzzy finder (fzf-lua)
  ---------------------------------------------------------------------------
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({
        "telescope", -- Use telescope-like defaults
        winopts = {
          height = 0.85,
          width = 0.80,
          row = 0.35,
          col = 0.50,
          border = "rounded",
          preview = {
            scrollbar = "float",
          },
        },
        keymap = {
          builtin = {
            ["<F1>"] = "toggle-help",
            ["<F2>"] = "toggle-fullscreen",
            ["<F3>"] = "toggle-preview-wrap",
            ["<F4>"] = "toggle-preview",
            ["<F5>"] = "toggle-preview-ccw",
            ["<F6>"] = "toggle-preview-cw",
            ["<PageDown>"] = "preview-page-down",
            ["<PageUp>"] = "preview-page-up",
            ["<S-down>"] = "preview-down",
            ["<S-up>"] = "preview-up",
          },
          fzf = {
            ["ctrl-z"] = "abort",
            ["ctrl-u"] = "unix-line-discard",
            ["ctrl-f"] = "half-page-down",
            ["ctrl-b"] = "half-page-up",
            ["ctrl-a"] = "beginning-of-line",
            ["ctrl-e"] = "end-of-line",
            ["alt-a"] = "toggle-all",
            ["f3"] = "toggle-preview-wrap",
            ["f4"] = "toggle-preview",
            ["shift-down"] = "preview-down",
            ["shift-up"] = "preview-up",
          },
        },
      })

      -- Fuzzy finder keymaps
      vim.keymap.set("n", "<C-p>", function()
        require("fzf-lua").files()
      end, { desc = "Find files" })
      vim.keymap.set("n", "<C-\\>", function()
        require("fzf-lua").buffers()
      end, { desc = "Find buffers" })
      vim.keymap.set("n", "<C-f>", function()
        require("fzf-lua").live_grep()
      end, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fw", function()
        require("fzf-lua").grep_cword()
      end, { desc = "Find word under cursor" })
      vim.keymap.set("n", "<leader>fh", function()
        require("fzf-lua").help_tags()
      end, { desc = "Find help" })
      vim.keymap.set("n", "<leader>fr", function()
        require("fzf-lua").resume()
      end, { desc = "Resume last search" })
      vim.keymap.set("n", "<leader>o", function()
        require("fzf-lua").resume()
      end, { desc = "Resume last search" })
    end,
  },

  ---------------------------------------------------------------------------
  -- Treesitter (syntax highlighting and text objects)
  ---------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Languages to auto-install
        ensure_installed = {
          "go",
          "lua",
          "python",
          "tsx",
          "typescript",
          "javascript",
          "json",
          "yaml",
          "vimdoc",
          "vim",
        },

        cc = "zig", -- C/C++ compiler for C/C++ files

        auto_install = false, -- Don't auto-install missing parsers

        highlight = { enable = true },
        indent = { enable = false }, -- Disabled as it can be unreliable

        -- Incremental selection
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<M-space>",
          },
        },

        -- Text objects for functions, classes, etc.
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Auto jump forward to textobj
            keymaps = {
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- Add jumps to jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      })
    end,
  },

  ---------------------------------------------------------------------------
  -- File explorer (Oil.nvim)
  ---------------------------------------------------------------------------
  {
    "stevearc/oil.nvim",
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    lazy = false,
    config = function()
      require("oil").setup({
        columns = { "icon", "permissions", "size", "mtime" },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-s>"] = false, -- Disable to avoid conflict
          ["<C-h>"] = false, -- Disable to avoid conflict
          ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open in new tab" },
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to oil directory" },
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
        view_options = {
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name, _)
            return name == ".." or name == ".git"
          end,
        },
        float = {
          padding = 2,
          max_width = 90,
          max_height = 0,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
          override = function(conf)
            return conf
          end,
        },
      })

      -- File explorer keymaps
      vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open file explorer" })
      vim.keymap.set("n", "<leader>E", function()
        require("oil").toggle_float()
      end, { desc = "Open file explorer (floating)" })
    end,
  },

  ---------------------------------------------------------------------------
  -- Git signs in gutter
  ---------------------------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  ---------------------------------------------------------------------------
  -- Smart commenting
  ---------------------------------------------------------------------------
  {
    "numToStr/Comment.nvim",
    opts = {},
  },

  ---------------------------------------------------------------------------
  -- LSP progress notifications
  ---------------------------------------------------------------------------
  {
    "j-hui/fidget.nvim",
    opts = {},
  },

  ---------------------------------------------------------------------------
  -- Better UI for messages, cmdline and popups
  ---------------------------------------------------------------------------
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        -- Override markdown rendering for cmp and other plugins
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,         -- Classic bottom cmdline for search
        command_palette = true,       -- Position cmdline and popupmenu together
        long_message_to_split = true, -- Long messages sent to split
        inc_rename = true,            -- Input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- Border for hover docs and signature help
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
}
