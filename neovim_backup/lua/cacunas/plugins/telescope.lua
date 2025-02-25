return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-tree/nvim-web-devicons',
    'folke/todo-comments.nvim',
  },
  config = function()
    local telescope = require 'telescope'
    local actions = require 'telescope.actions'

    telescope.setup {
      path_display = { 'smart' },
      mappings = {
        i = {
          ['<C-k>'] = actions.move_selection_previous, -- move to previous result
          ['<C-j>'] = actions.move_selection_next, -- move to next result
          ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
        },
      },
    }

    telescope.load_extension 'fzf'

    -- set keymaps
    local keymap = vim.keymap

    keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = '[F]uzzy-find [F]ile in pwd' })
    keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>', { desc = '[F]uzzy-find [R]ecent file' })
    keymap.set('n', '<leader>ft', '<cmd>Telescope live_grep<cr>', { desc = '[F]uzzy-find [T]ext' })
    keymap.set('n', '<leader>fc', '<cmd>Telescope grep_string<cr>', { desc = '[F]uzzy-find text under [C]ursor' })
    keymap.set('n', '<leader>fT', '<cmd>Telescope grep_string<cr>', { desc = '[F]uzzy-find [T]odo comment' })
  end,
}
