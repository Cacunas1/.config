return {
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
            "hkupty/iron.nvim", -- repl provider
            "anuvyklack/hydra.nvim",
        },
        event = "VeryLazy",
        config = function()
            local nn = require("notebook-navigator")
            nn.setup({
                activate_hydra_keys = nil, -- Disable Hydra initially to avoid errors
                syntax_highlight = true, -- Use simpler highlighting instead of mini.hipatterns
            })
        end,
    },

    -- Add Mini.hipatterns for cell highlighting
    {
        "echasnovski/mini.hipatterns",
        event = "VeryLazy",
        dependencies = { "GCBallesteros/NotebookNavigator.nvim" },
        opts = function()
            local nn = require("notebook-navigator")
            local opts = { highlighters = { cells = nn.minihipatterns_spec } }
            return opts
        end,
    },

    -- Add Mini.ai for cell text object
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        dependencies = { "GCBallesteros/NotebookNavigator.nvim" },
        opts = function()
            local nn = require("notebook-navigator")
            local opts = { custom_textobjects = { h = nn.miniai_spec } }
            return opts
        end,
    },
}
