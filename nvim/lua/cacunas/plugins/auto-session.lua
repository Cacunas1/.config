return {
  'rmagatti/auto-session',
  config = function()
    local auto_session = require 'auto-session'

    auto_session.setup {
      auto_Restore_enabled = false,
      auto_session_supperss_dirs = { '~/', '~/Downloads', '~/Documents', '~/Desktop' },
    }

    local keymap = vim.keymap

    keymap.set('n', '<leader>sr', '<cmd>SessionRestore<cr>', { desc = '[S]ession [R]estore' })
    keymap.set('n', '<leader>ss', '<cmd>SessionRestore<cr>', { desc = '[S]ession [S]ave (for auto-session root dir)' })
  end,
}
