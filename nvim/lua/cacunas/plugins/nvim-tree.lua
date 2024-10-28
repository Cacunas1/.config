return {
  'nvim-tree/nvim-tree.lua',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    local nvimtree = require 'nvim-tree'

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netwr = 1
    vim.g.loaded_netwrPlugin = 1

    nvimtree.setup {
      view = {
        width = 35,
        relativenumber = true,
      },
      -- change folder arrow keys
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {
            folder = {
              arrow_closed = '-',
              arrow_open = '+',
            },
          },
        },
      },
      -- disable window_picker for explorer
      -- to work well with window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      git = {
        ignore = false,
      },
    }

    -- set keymaps
    local keymap = vim.keymap

    keymap.set('n', '<leader>et', '<cmd>NvimTreeToggle<CR>', { desc = 'File [E]xplorer [T]oggle' })
    keymap.set('n', '<leader>ef', '<cmd>NvimTreeFindFileToggle<CR>', { desc = 'File [E]xplorer [F]ind' })
    keymap.set('n', '<leader>ec', '<cmd>NvimTreeCollapse<CR>', { desc = 'File [E]xplorer [C]ollapse' })
    keymap.set('n', '<leader>er', '<cmd>NvimTreeRefresh<CR>', { desc = 'File [E]xplorer [R]efresh' })
  end,
}
