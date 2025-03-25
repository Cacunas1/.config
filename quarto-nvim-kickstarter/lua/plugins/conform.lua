return {
  "stevearc/conform.nvim",
  ---@class ConformOpts
  opts = {
    formatters = {
      -- Prettier configuration in conform.nvim
      prettier = {
        options = {
          ext_parsers = {
            qmd = "markdown",
          },
        },
      },
    },
    formatters_by_ft = {
      -- ...
      quarto = { "prettierd", "prettier" },
      -- ...
    },
  },
}
