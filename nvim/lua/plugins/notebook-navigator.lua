return {
    -- First, configure iron.nvim properly
    {
        "hkupty/iron.nvim",
        version = "*",
        lazy = true,
        config = function()
            local iron = require("iron.core")

            iron.setup({
                config = {
                    -- Close the REPL when the corresponding buffer is closed
                    close_on_bdelete = true,
                    -- Set a repl for each filetype
                    repl_definition = {
                        python = {
                            command = { "ipython" },
                            -- Format string used for the displayed REPL buffer name
                            format = "ipython",
                        },
                        -- Add more languages as needed
                        lua = {
                            command = { "lua" },
                        },
                        -- r = {
                        --     command = { "R" },
                        -- },
                        -- julia = {
                        --     command = { "julia" },
                        -- },
                    },
                    -- Default highlight group for the REPL window
                    highlight = {
                        italic = true,
                    },
                    ignore_blank_lines = true, -- ignored blank lines when sending visual select lines
                },
                -- Keymaps for the REPL
                keymaps = {
                    send_motion = "<leader>sc",
                    visual_send = "<leader>sc",
                    send_file = "<leader>sf",
                    send_line = "<leader>sl",
                    send_mark = "<leader>sm",
                    mark_motion = "<leader>mc",
                    mark_visual = "<leader>mc",
                    remove_mark = "<leader>md",
                    cr = "<leader>s<cr>",
                    interrupt = "<leader>s<leader>",
                    exit = "<leader>sq",
                    clear = "<leader>cl",
                },
                -- Whether iron should map the defaults keymaps or not
                highlight_last = true,
                -- Iron doesn't automatically open a REPL window, but will focus it if it's already opened
                focus_on_open = true,
            })
        end,
    },

    -- Then, configure NotebookNavigator with iron.nvim
    {
        "GCBallesteros/NotebookNavigator.nvim",
        keys = {
            {
                "]h",
                function()
                    require("notebook-navigator").move_cell("d")
                end,
                desc = "Move to next cell",
            },
            {
                "[h",
                function()
                    require("notebook-navigator").move_cell("u")
                end,
                desc = "Move to previous cell",
            },
            {
                "<leader>X",
                function()
                    require("notebook-navigator").run_cell()
                end,
                desc = "Run current cell",
            },
            {
                "<leader>x",
                function()
                    require("notebook-navigator").run_and_move()
                end,
                desc = "Run cell and move to next",
            },
        },
        dependencies = {
            "echasnovski/mini.comment",
            "hkupty/iron.nvim",
            "anuvyklack/hydra.nvim",
        },
        config = function()
            local nn = require("notebook-navigator")
            nn.setup({
                activate_hydra_keys = "<leader>h",
                repl_provider = "iron", -- Explicitly set to iron
                syntax_highlight = true,
            })
        end,
    },

    -- Add Mini.ai for cell text object (optional)
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        dependencies = { "GCBallesteros/NotebookNavigator.nvim" },
        opts = function()
            local nn = require("notebook-navigator")
            if nn and nn.miniai_spec then
                local opts = { custom_textobjects = { h = nn.miniai_spec } }
                return opts
            end
            return {}
        end,
    },
}
