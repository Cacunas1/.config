-- init.lua for Jupyter Notebook editing in Neovim
-- This configuration uses lazy.nvim as the plugin manager
-- It provides a complete setup for working with Jupyter notebooks in Neovim

-- Set up global Neovim options
vim.g.mapleader = " " -- Set leader key to space
vim.g.maplocalleader = "," -- Set local leader key to comma

-- Basic Neovim settings
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.tabstop = 4 -- Number of spaces tabs count for
vim.opt.shiftwidth = 4 -- Size of an indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.wrap = false -- Disable line wrap
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override ignorecase if search contains uppercase
vim.opt.termguicolors = true -- True color support
vim.opt.cursorline = true -- Highlight the current line
vim.opt.signcolumn = "yes" -- Always show the signcolumn
vim.opt.updatetime = 300 -- Faster update time for better user experience
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.mouse = "a" -- Enable mouse usage in all modes

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Define plugins with lazy.nvim
require("lazy").setup({
	-- Color scheme
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},

	-- Treesitter for syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"python",
					"lua",
					"bash",
					"markdown",
					"markdown_inline",
					"json",
					"julia",
					"r",
					"yaml",
					"toml",
					"html",
				},
				highlight = { enable = true },
				indent = { enable = true },
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
				},
			})
		end,
	},

	-- Which-key for keybinding hints
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup()

			-- Register jupyter notebook specific keybindings
			require("which-key").add({
				j = {
					name = "Jupyter",
					e = { "<cmd>MoltenEvaluateOperator<cr>", "Evaluate Operator" },
					l = { "<cmd>MoltenEvaluateLine<cr>", "Evaluate Line" },
					c = { "<cmd>MoltenEvaluateCell<cr>", "Evaluate Cell" },
					n = { "<cmd>MoltenEvaluateCellAndGotoNext<cr>", "Evaluate Cell & Go Next" },
					r = { "<cmd>MoltenReevaluateCell<cr>", "Re-evaluate Cell" },
					d = { "<cmd>MoltenDelete<cr>", "Delete Cell Output" },
					s = { "<cmd>MoltenInit<cr>", "Initialize Molten" },
					x = { "<cmd>MoltenInterrupt<cr>", "Interrupt Execution" },
				},
			}, { prefix = "<leader>" })
		end,
	},

	-- LSP configuration with mason.nvim
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim", -- Better Lua development for Neovim
			"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
			"hrsh7th/nvim-cmp", -- Completion plugin
			"L3MON4D3/LuaSnip", -- Snippet engine
			"saadparwaiz1/cmp_luasnip", -- Luasnip source for cmp
			"onsails/lspkind.nvim", -- VS Code-like pictograms
		},
		config = function()
			-- Set up neodev (must be before lspconfig)
			require("neodev").setup()

			-- Set up mason
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			-- Configure mason-lspconfig
			require("mason-lspconfig").setup({
				ensure_installed = {
					"pyright", -- Python
					"lua_ls", -- Lua
					"r_language_server", -- R
					"julials", -- Julia
					"marksman", -- Markdown
					"jsonls", -- JSON
					"yamlls", -- YAML
				},
				automatic_installation = true,
			})

			-- Set up nvim-cmp
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

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
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
					}),
				},
			})

			-- Configure LSP capabilities with cmp
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Set up key bindings for LSP
			local on_attach = function(client, bufnr)
				local opts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
			end

			-- Set up each LSP server
			local lspconfig = require("lspconfig")

			-- Python
			lspconfig.pyright.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
						},
					},
				},
			})

			-- Lua
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			-- Markdown
			lspconfig.marksman.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- R
			lspconfig.r_language_server.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- Julia
			lspconfig.julials.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end,
	},

	-- Telescope for fuzzy finding
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					file_ignore_patterns = { "node_modules", ".git", ".ipynb_checkpoints" },
					mappings = {
						i = {
							["<C-j>"] = "move_selection_next",
							["<C-k>"] = "move_selection_previous",
						},
					},
				},
				pickers = {
					find_files = {
						hidden = true,
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			telescope.load_extension("fzf")

			-- Telescope keybindings
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
		end,
	},

	-- Hydra for creating modal interfaces
	{
		"anuvyklack/hydra.nvim",
		config = function()
			local Hydra = require("hydra")

			-- Create a Jupyter hydra menu
			Hydra({
				name = "Jupyter",
				mode = "n",
				body = "<leader>h",
				heads = {
					{ "i", ":MoltenInit<CR>", { desc = "Initialize Kernel" } },
					{ "e", ":MoltenEvaluateCell<CR>", { desc = "Evaluate Cell" } },
					{ "n", ":MoltenEvaluateCellAndGotoNext<CR>", { desc = "Evaluate & Next" } },
					{ "r", ":MoltenReevaluateCell<CR>", { desc = "Re-evaluate Cell" } },
					{ "d", ":MoltenDelete<CR>", { desc = "Delete Results" } },
					{ "x", ":MoltenInterrupt<CR>", { desc = "Interrupt Kernel" } },
					{ "q", nil, { exit = true, desc = "Quit" } },
				},
			})
		end,
	},

	-- Jupytext for converting between ipynb and markdown
	{
		"GCBallesteros/jupytext.nvim",
		dependencies = {
			"echasnovski/mini.nvim", -- Required for jupytext
		},
		config = function()
			require("jupytext").setup({
				style = "markdown", -- Convert to/from markdown format
				output_extension = "md", -- Use .md extension for the converted files
				custom_language_formatting = {
					python = {
						-- Use triple backticks with 'python' for python code
						comment_string = "#",
					},
					r = {
						-- For R code blocks
						comment_string = "#",
					},
				},
			})
		end,
	},

	-- Molten for executing code cells
	{
		"benlubas/molten-nvim",
		version = "^1.0.0", -- Use the latest 1.x release
		dependencies = {
			"3rd/image.nvim", -- For image support
		},
		build = ":UpdateRemotePlugins",
		init = function()
			-- Once molten-nvim is loaded, initialize it
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_output_win_max_height = 20
			vim.g.molten_auto_open_output = true
			vim.g.molten_wrap_output = true
			vim.g.molten_virt_text_output = true

			-- Set Python as default
			vim.g.molten_default_python_kernel = "python3"

			-- Auto-init when opening a notebook
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				pattern = { "*.ipynb" },
				callback = function()
					vim.defer_fn(function()
						vim.cmd("MoltenInit")
					end, 100)
				end,
			})
		end,
	},

	-- Quarto for scientific and technical publishing
	{
		"quarto-dev/quarto-nvim",
		dependencies = {
			"jmbuhr/otter.nvim", -- You added this to your list
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("quarto").setup({
				debug = false,
				closePreviewOnExit = true,
				lspFeatures = {
					enabled = true,
					languages = { "r", "python", "julia", "bash" },
					chunks = "curly", -- 'curly' or 'all'
					diagnostics = {
						enabled = true,
						triggers = { "BufWritePost" },
					},
					completion = {
						enabled = true,
					},
				},
				keymap = {
					hover = "K",
					definition = "gd",
					type_definition = "gt",
					rename = "<leader>rn",
					format = "<leader>f",
					references = "gr",
					document_symbols = "gS",
				},
			})
		end,
	},

	-- Otter provides LSP features for code chunks in markdown
	{
		"jmbuhr/otter.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("otter").setup({
				lsp = {
					hover = {
						border = "single",
					},
				},
			})
		end,
	},

	-- Additional plugins for a better experience

	-- Auto-pairs for brackets, quotes, etc.
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	-- Mini.nvim for various small utilities
	{
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			-- Enable mini.comment for easier commenting
			require("mini.comment").setup()

			-- Enable mini.surround for surrounding text objects
			require("mini.surround").setup()

			-- Enable mini.statusline for a lightweight statusline
			require("mini.statusline").setup()
		end,
	},

	-- Lualine for a better statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "tokyonight",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {},
					always_divide_middle = true,
					globalstatus = false,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				extensions = {},
			})
		end,
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("ibl").setup()
		end,
	},

	-- Git integration
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},

	-- 3rd/image.nvim for image display in Neovim
	{
		"3rd/image.nvim",
		config = function()
			require("image").setup({
				backend = "kitty", -- Use kitty for image rendering
				integrations = {
					markdown = {
						enabled = true,
						clear_in_insert_mode = false,
						download_remote_images = true,
						only_render_image_at_cursor = false,
						filetypes = { "markdown", "vimwiki", "quarto" },
					},
				},
				max_width = 100,
				max_height = 15,
				max_width_window_percentage = math.huge,
				max_height_window_percentage = math.huge,
			})
		end,
	},
})

-- Set up autocommands for working with Jupyter notebooks
vim.api.nvim_create_augroup("jupyter_notebook", { clear = true })

-- When opening an ipynb file, convert it to markdown using jupytext
vim.api.nvim_create_autocmd({ "BufReadCmd" }, {
	pattern = "*.ipynb",
	group = "jupyter_notebook",
	callback = function()
		-- Auto-convert ipynb to markdown on open
		local filepath = vim.fn.expand("%")
		vim.cmd("JupytextToMd")
	end,
})

-- When saving a markdown file that was originally an ipynb, convert it back
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = "*.md",
	group = "jupyter_notebook",
	callback = function()
		-- Check if this was originally a jupyter notebook file
		local orig_path = vim.fn.expand("%:r") .. ".ipynb"
		if vim.fn.filereadable(orig_path) == 1 then
			vim.cmd("JupytextToIpynb")
		end
	end,
})

-- Enable syntax highlighting for fenced code blocks in markdown
vim.g.markdown_fenced_languages = {
	"python",
	"bash",
	"sh",
	"r",
	"julia",
	"lua",
	"html",
	"css",
	"javascript",
	"js=javascript",
	"json",
	"yaml",
	"toml",
}

-- Custom commands for Jupyter notebook workflows
vim.api.nvim_create_user_command("JupyterOpenInBrowser", function()
	local notebook_file = vim.fn.expand("%:r") .. ".ipynb"
	if vim.fn.filereadable(notebook_file) == 1 then
		vim.fn.system({ "jupyter", "notebook", notebook_file })
	else
		vim.notify("Cannot find associated notebook file", vim.log.levels.ERROR)
	end
end, { desc = "Open current notebook in Jupyter browser interface" })

vim.api.nvim_create_user_command("JupyterStartServer", function()
	vim.fn.system({ "jupyter", "notebook" })
	vim.notify("Jupyter server started", vim.log.levels.INFO)
end, { desc = "Start Jupyter notebook server" })

-- Additional key mappings for Jupyter notebook editing
-- Molten key mappings
vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>", { desc = "Initialize Molten" })
vim.keymap.set("n", "<localleader>me", ":MoltenEvaluateCell<CR>", { desc = "Evaluate Cell" })
vim.keymap.set("n", "<localleader>mn", ":MoltenEvaluateCellAndGotoNext<CR>", { desc = "Evaluate Cell and Go to Next" })
vim.keymap.set("n", "<localleader>mr", ":MoltenReevaluateCell<CR>", { desc = "Re-evaluate Cell" })
vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>", { desc = "Delete Molten Results" })
vim.keymap.set("n", "<localleader>mx", ":MoltenInterrupt<CR>", { desc = "Interrupt Kernel" })
vim.keymap.set("n", "<localleader>mo", ":JupyterOpenInBrowser<CR>", { desc = "Open in Jupyter Browser" })
vim.keymap.set("n", "<localleader>ms", ":JupyterStartServer<CR>", { desc = "Start Jupyter Server" })

-- Visually select a code cell (from one ```python to the next ```)
vim.keymap.set("n", "vic", "?```<CR>V/```<CR>", { desc = "Select Code Cell" })

-- Print a helpful message when starting Neovim with this config
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.notify(
			[[
      Jupyter Notebook Configuration Loaded!
      
      Key mappings:
      <localleader>mi - Initialize Molten kernel
      <localleader>me - Evaluate current cell
      <localleader>mn - Evaluate cell and go to next
      <localleader>mr - Re-evaluate cell
      <localleader>md - Delete results
      <localleader>mx - Interrupt kernel
      <localleader>mo - Open in Jupyter browser
      <localleader>ms - Start Jupyter server
      
      <leader>h    - Hydra menu for Jupyter operations
      
      Note: <localleader> is set to ','
    ]],
			vim.log.levels.INFO
		)
	end,
})
