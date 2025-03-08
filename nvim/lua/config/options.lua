-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Neovide specific setup
if vim.g.neovide then
    vim.o.guifont = "Fira Code:h10" -- text below applies for VimScript
    vim.g.neovide_transparency = 0.8
    vim.g.neovide_normal_opacity = 0.8
end

local opt = vim.opt
-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10
