vim.g.mapleader = ' '

local keymap = vim.keymap -- for conciseness

-- Escape modes with fd like in Spacemacs
keymap.set('i', 'fd', '<ESC>', { desc = 'Exit insert mode with fd' })
keymap.set('v', 'fd', '<ESC>', { desc = 'Exit visual mode with fd' })

-- Save file

-- Clear search highlights
keymap.set('n', '<leader>hc', ':nohl<CR>', { desc = '[H]ighlight [C]lear (clear search highlights)' })

-- Increment/decrement numbers
keymap.set('n', '<leader>+', '<C-a>', { desc = 'Increment number' })
keymap.set('n', '<leader>-', '<C-x>', { desc = 'Decrement number' })

-- window management
keymap.set('n', '<leader>w/', '<C-w>v', { desc = '[W]indow split vertical' })
keymap.set('n', '<leader>w-', '<C-w>s', { desc = '[W]indow split horizontal' })
keymap.set('n', '<leader>w=', '<C-w>=', { desc = '[W]indow make split equal (=) size' })
keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Move to left [W]indow' })
keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Move to right [W]indow' })
keymap.set('n', '<leader>wj', '<C-w>j', { desc = 'Move to upper [W]indow' })
keymap.set('n', '<leader>wk', '<C-w>k', { desc = 'Move to lower [W]indow' })
keymap.set('n', '<leader>wd', '<cmd>close<CR>', { desc = '[W]indow [D]elete' })

-- tab management
keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', { desc = '[T]ab [O]pen' })
keymap.set('n', '<leader>td', '<cmd>tabclose<CR>', { desc = '[T]ab [D]elete' })
keymap.set('n', '<leader>tn', '<cmd>tabn<CR>', { desc = '[T]ab [N]ext' })
keymap.set('n', '<leader>tp', '<cmd>tabp<CR>', { desc = '[T]ab [P]previous' })
keymap.set('n', '<leader>tf', '<cmd>tabnew %<CR>', { desc = '[T]ab open bu[F]fer in new tab (?)' })

-- buffer management
keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[B]uffer [D]elete' })
keymap.set('n', '<leader>bn', '<cmd>bnext<CR>', { desc = '[B]uffer [N]ext' })
keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>', { desc = '[B]uffer [P]revious' })
keymap.set('n', '<leader>bb', '<cmd>buffers<CR>', { desc = '[B]uffer of [B]uffers' })
keymap.set('n', '<leader>fs', ':w<CR>', { desc = '[F]ile (Buffer) [S]ave' })

-- Quit vim
keymap.set('n', '<leader>qq', '<cmd>qa<CR>', { desc = 'Quit NVIM' })
