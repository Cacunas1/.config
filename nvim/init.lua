-- init.lua - Minimal Neovim Configuration with LSP, Git, REPL Support
-- This configuration uses lazy.nvim for plugin management and mason.nvim for LSP/tools

-- Set leader key to space (should be set before lazy.nvim is loaded)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic Neovim settings
vim.opt.number = true               -- Show line numbers
vim.opt.relativenumber = true       -- Show relative line numbers
vim.opt.mouse = 'a'                 -- Enable mouse support
vim.opt.ignorecase = true           -- Ignore case in search
vim.opt.smartcase = true            -- Override ignorecase if search contains uppercase
vim.opt.hlsearch = true             -- Highlight search results
vim.opt.wrap = true                 -- Wrap long lines
vim.opt.breakindent = true          -- Preserve indentation in wrapped text
vim.opt.tabstop = 4                 -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4              -- Number of spaces for autoindent
vim.opt.expandtab = true            -- Convert tabs to spaces
vim.opt.cursorline = true           -- Highlight current line
vim.opt.termguicolors = true        -- True color support
vim.opt.splitright = true           -- Open vertical splits to the right
vim.opt.splitbelow = true           -- Open horizontal splits below
vim.opt.backup = false              -- Don't create backup files
vim.opt.writebackup = false         -- Don't make backup before overwriting
vim.opt.swapfile = false            -- Don't use swapfile
vim.opt.undofile = true             -- Persistent undo
vim.opt.updatetime = 250            -- Faster update time (default is 4000ms)
vim.opt.signcolumn = "yes"          -- Always show sign column
vim.opt.scrolloff = 8               -- Lines of context around cursor
vim.opt.clipboard:append("unnamedplus") -- use system clipboard

-- Spellcheck settings
vim.opt.spell = true                -- Enable spell checking
vim.opt.spelllang = {"en", "es"}    -- Set languages for spell checking

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specification with lazy.nvim
require("lazy").setup({
  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
      })
      vim.cmd.colorscheme "catppuccin"
    end,
  },
  
  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>et", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
    },
  },
  
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", group = "Telescope [f]ind" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find [f]iles" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find in files (grep)" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find help" },
    },
    config = function()
      require("telescope").setup({
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
      require("telescope").load_extension("fzf")
    end,
  },
  
  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
  },
  
  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "python", "rust", "markdown", "markdown_inline",
          "latex", "bash", "json", "yaml", "toml", "html", "css", "javascript"
        },
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = { enable = true },
      })
    end,
  },
  
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      
      -- Useful status updates for LSP
      { "j-hui/fidget.nvim", opts = {} },
      
      -- Additional lua configuration for nvim
      "folke/neodev.nvim",
    },
    config = function()
      -- Setup neodev for better Lua development in Neovim configurations
      require("neodev").setup()
      
      -- Mason setup for LSP, formatters, and linters installation
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
      
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",           -- Python
          "rust_analyzer",     -- Rust
          "texlab",            -- LaTeX
          "marksman",          -- Markdown
        },
        automatic_installation = true,
      })
      
      -- Ensure formatters and linters are installed
      require("mason-tool-installer").setup({
        ensure_installed = {
          "black",             -- Python formatter
          "isort",             -- Python import formatter
          "pylint",            -- Python linter
          "stylua",            -- Lua formatter
          "latexindent",       -- LaTeX formatter
          "prettier",          -- Various formatters (markdown, etc.)
          "rustfmt",           -- Rust formatter
        },
      })
      
      -- LSP settings
      local lspconfig = require("lspconfig")
      
      -- Define on_attach function to set keymaps after LSP attaches
      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        
        -- LSP keybindings
        opts.desc = "[g]o to [d]eclaration"
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                opts.desc = "[g]o to [d]efinition"
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                opts.desc = "LSP Hover docs"
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                opts.desc = "[g]o to [i]mplementation"
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                opts.desc = "LSP signature help"
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        --         opts.desc = "[w]orkspace [a]dd"
        -- vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
        --         opts.desc = "[w]orkspace [r]emove"
        -- vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
        --         opts.desc = "[w]orkspace [l]ist"
        -- vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
                opts.desc = "[g]o to [t]ype definition"
        vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, opts)
                opts.desc = "[r]e[n]name"
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                opts.desc = "[c]ode [a]ction"
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                opts.desc = "[g]o to [r]eferences"
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                opts.desc = "[b]uffer [f]ormat"
        vim.keymap.set("n", "<leader>bf", function() vim.lsp.buf.format({ async = true }) end, opts)
        
        -- Enable formatting on save if the client supports it
        if client.supports_method("textDocument/formatting") then
          local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ 
                bufnr = bufnr,
                timeout_ms = 2000
              })
            end,
          })
        end
      end
      
      -- Configure LSP servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      -- Python LSP setup
      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            },
          },
        },
      })
      
      -- Rust LSP setup
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      })
      
      -- LaTeX LSP setup
      lspconfig.texlab.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      
      -- Markdown LSP setup
      lspconfig.marksman.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
      
      -- Add more LSP configurations as needed
    end,
  },
  
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      
      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
      
      -- Set up autocomplete for command line mode
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })
    end,
  },
  
  -- Git integration
  {
    "TimUntersberger/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" },
    },
    config = true,
  },
  
  -- For Lazygit integration
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
    },
  },
  
  -- REPL Support
  {
    "michaelb/sniprun",
    build = "bash ./install.sh",
    keys = {
      { "<leader>sr", "<cmd>SnipRun<cr>", desc = "Run code snippet" },
      { "<leader>sl", "<cmd>SnipLive<cr>", desc = "Live code execution" },
    },
    config = true,
  },
  
  -- Jupyter Notebook support
  {
    "kiyoon/jupynium.nvim",
    build = "pip install --user .",
    dependencies = {
      "rcarriga/nvim-notify",   -- Optional
    },
    keys = {
      { "<leader>jr", "<cmd>JupyniumStartSync<cr>", desc = "Start Jupynium" },
      { "<leader>jc", "<cmd>JupyniumConnect<cr>", desc = "Connect to Jupyter" },
    },
    config = true,
  },
  
  -- Quarto notebook support
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "hrsh7th/nvim-cmp",
    },
    keys = {
      { "<leader>qp", "<cmd>QuartoPreview<cr>", desc = "Preview Quarto document" },
    },
    config = function()
      require("quarto").setup({
        lspFeatures = {
          enabled = true,
          languages = { "r", "python", "julia" },
          diagnostics = { enabled = true },
          completion = { enabled = true },
        },
      })
    end,
  },
  
  -- Pairs management (auto-close brackets, quotes, etc.)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  
  -- Comment toggles
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", desc = "Comment current line" },
      { "gc", mode = "v", desc = "Comment visual selection" },
    },
    config = true,
  },
  
  -- Better terminal integration
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    },
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<C-\>]],
        direction = "float",
        float_opts = {
          border = "curved",
        },
      })
      
      -- Function to create language-specific REPLs
      local function create_repl(command, mapping, desc)
        vim.keymap.set("n", mapping, function() 
          require("toggleterm.terminal").Terminal:new({ cmd = command, hidden = true }):toggle() 
        end, { desc = desc })
      end
      
      -- Create language-specific REPL shortcuts
      create_repl("python", "<leader>tp", "Open Python REPL")
      create_repl("ipython", "<leader>ti", "Open iPython REPL")
      create_repl("rustup run nightly rust-analyzer", "<leader>tr", "Open Rust REPL")
    end,
  },
  
  -- Which key helper for keybindings
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({
        window = {
          border = "rounded",
        },
      })
      
      -- Register key group prefixes for better organization
      require("which-key").register(
                {
                    { "<leader>f", group = "Find (Telescope)" },
                    { "<leader>g", group = "Git" },
                    { "<leader>j", group = "Jupyter" },
                    { "<leader>l", group = "LSP" },
                    { "<leader>q", group = "Quarto" },
                    { "<leader>s", group = "Snippet/Run" },
                    { "<leader>t", group = "Terminal/REPL" },
                    { '<leader>w', group = "[w]indow" },
                    { '<leader>t', group = "[t]ab" },
                    { '<leader>b', group = "[b]uffer" },
                }
)
    end,
  },
})

-- Additional keymaps (not plugin-specific)
-- vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
-- vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
-- vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Quick navigation between splits
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Terminal mode mappings
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Helper function to organize init.lua
vim.api.nvim_create_user_command("EditConfig", "edit $MYVIMRC", { desc = "Edit Neovim configuration" })
vim.keymap.set("n", "<leader>fc", "<cmd>EditConfig<cr>", { desc = "[f]ind [c]onfiguration" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics list" })

-- Setup spell checking
vim.opt.spell = true
vim.opt.spelllang = { "en", "es" }
vim.keymap.set("n", "<leader>ss", "<cmd>set spell!<cr>", { desc = "Toggle spell check" })

-- Print a message when the configuration is loaded
print("Neovim configuration loaded successfully!")

-- Neovide specific setup
if vim.g.neovide then
  vim.o.guifont = "Fira Code:h10"
  vim.g.neovide_transparency = 0.9
  vim.g.neovide_normal_opacity = 0.9
end

-- Cacunas keymaps
local keymap = vim.keymap -- for conciseness

-- Escape modes with fd like in Spacemacs
-- keymap.set({'i', 'v'}, 'fd', '<ESC>', { desc = 'Exit insert mode with fd' })

-- Clear search highlights
keymap.set('n', '<leader>hc', ':nohl<CR>', { desc = '[h]ighlight [c]lear (clear search highlights)' })

-- Increment/decrement numbers
keymap.set('n', '<leader>+', '<C-a>', { desc = 'Increment number' })
keymap.set('n', '<leader>-', '<C-x>', { desc = 'Decrement number' })

-- window management

keymap.set('n', '<leader>w/', '<C-w>v', { desc = '[w]indow split vertical' })
keymap.set('n', '<leader>w-', '<C-w>s', { desc = '[w]indow split horizontal' })
keymap.set('n', '<leader>w=', '<C-w>=', { desc = '[w]indow make split equal (=) size' })
keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Move to left [w]indow' })
keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Move to right [w]indow' })
keymap.set('n', '<leader>wj', '<C-w>j', { desc = 'Move to upper [w]indow' })
keymap.set('n', '<leader>wk', '<C-w>k', { desc = 'Move to lower [w]indow' })
keymap.set('n', '<leader>wd', '<cmd>close<CR>', { desc = '[w]indow [d]elete' })

-- tab management
keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', { desc = '[t]ab [o]pen' })
keymap.set('n', '<leader>td', '<cmd>tabclose<CR>', { desc = '[t]ab [d]elete' })
keymap.set('n', '<leader>tn', '<cmd>tabn<CR>', { desc = '[t]ab [n]ext' })
keymap.set('n', '<leader>tp', '<cmd>tabp<CR>', { desc = '[t]ab [p]previous' })
keymap.set('n', '<leader>tf', '<cmd>tabnew %<CR>', { desc = '[t]ab open bu[f]fer in new tab (?)' })

-- buffer management
keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[b]uffer [d]elete' })
keymap.set('n', '<leader>bn', '<cmd>bnext<CR>', { desc = '[b]uffer [n]ext' })
keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>', { desc = '[b]uffer [p]revious' })
keymap.set('n', '<leader>bb', '<cmd>buffers<CR>', { desc = '[b]uffer of [b]uffers' })

-- Save file
keymap.set('n', '<leader>fs', ':w<CR>', { desc = '[f]ile (Buffer) [s]ave' })

-- Quit vim
keymap.set('n', '<leader>qq', '<cmd>qa<CR>', { desc = 'Quit NVIM' })

