return {
  {
    'echasnovski/mini.nvim',
    version = '*',
  },
  {
    'echasnovski/mini.trailspace',
    event = { 'BufReadPost', 'BufNewFile' },
    -- stylua: ignore
    keys = {
        { '<leader>ec', '<cmd>lua MiniTrailspace.trim()<CR>', desc = 'edit [c]lean (whitespace)' },
    },
    opts = {},
    setup = {
      -- Highlight only in normal buffers (ones with empty 'buftype'). This is
      -- useful to not show trailing whitespace where it usually doesn't matter.
      only_in_normal_buffers = true,
    },
  },
}
