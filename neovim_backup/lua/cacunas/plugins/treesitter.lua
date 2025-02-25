return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPre', 'BufNewFile' },
  build = ':TSUpdate',
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require 'nvim-treesitter.configs'

    -- configure treesitter
    treesitter.setup {
      highlight = { enable = true },
      -- enable indentation
      indent = { enable = true },
      ensure_installed = {
        'python',
        'lua',
        'bash',
        'vim',
        'query',
        'gitignore',
        'markdown',
        'markdown_inline',
        'yaml',
        'toml',
        'rust',
        'c',
        'sql',
        'org',
        'json',
        'json5',
        'csv',
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
    }
  end,
}
