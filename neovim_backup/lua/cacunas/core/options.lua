vim.cmd 'let g:netrw_liststyle = 3'

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

-- colors & appearance stuff
opt.termguicolors = true
opt.background = 'dark'
opt.signcolumn = 'yes'

-- backspace
opt.backspace = 'indent,eol,start'

-- clipboard
opt.clipboard = 'unnamedplus' -- use system clipboard as default register

-- split windows
opt.splitright = true
opt.splitbelow = true

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10

-- Set spellchecker languages
opt.spell = true
-- opt.spelllang = { 'en', 'es' }

if vim.g.neovide then
  -- Put anything you want to happen only in Neovide here
  vim.o.guifont = 'Source Code Pro:h12' -- text below applies for VimScript
  vim.g.neovide_transparency = 0.9
  vim.g.neovide_normal_opacity = 0.9
end

-- :checkhealth recommendations
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
