-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap -- for conciseness

-- window management
keymap.set("n", "<leader>w/", "<C-w>v", { desc = "[W]indow split vertical" })
keymap.set("n", "<leader>w-", "<C-w>s", { desc = "[W]indow split horizontal" })
keymap.set("n", "<leader>w=", "<C-w>=", { desc = "[W]indow make split equal (=) size" })
keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Move to left [W]indow" })
keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Move to right [W]indow" })
keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Move to upper [W]indow" })
keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Move to lower [W]indow" })
keymap.set("n", "<leader>wd", "<cmd>close<CR>", { desc = "[W]indow [D]elete" })

-- tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "[T]ab [O]pen" })
keymap.set("n", "<leader>td", "<cmd>tabclose<CR>", { desc = "[T]ab [D]elete" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "[T]ab [N]ext" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "[T]ab [P]previous" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "[T]ab open bu[F]fer in new tab (?)" })

-- file save
-- keymap.set("n", "<leader>ss", ":w<CR>", { desc = "[F]ile (Buffer) [S]ave" })
