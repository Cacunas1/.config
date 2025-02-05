return {
  'stevearc/conform.nvim',
  event = { 'LspAttach', 'BufReadPre', 'BufNewFile' },
  config = function()
    local conform = require 'conform'

    conform.setup {
      formatters_by_ft = {
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
        graphql = { 'prettier' },
        lua = { 'stylua' },
        python = { 'ruff' },
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 2500,
      },
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>mp', function()
      conform.format {
        lsp_fallback = true,
        async = true,
        timeout_ms = 2500,
      }
    end, { desc = 'Format file or range (in visual mode)' })
  end,
}
