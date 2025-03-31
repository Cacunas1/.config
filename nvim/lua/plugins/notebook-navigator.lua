-- Iron.nvim configuration
return {
    {
        "hkupty/iron.nvim",
        version = "*",
        lazy = false, -- Important to ensure it's loaded before NotebookNavigator
        priority = 1000, -- High priority to load before other plugins
        config = function()
            local iron = require("iron.core")
            -- local view = require("iron.view")
            local common = require("iron.fts.common")

            iron.setup({
                config = {
                    -- Whether a repl should be discarded or not
                    scratch_repl = true,
                    -- Your repl definitions come here

                    repl_definition = {
                        sh = {
                            command = { "zsh" },
                        },
                        python = {
                            command = { "python3" }, -- or { "ipython", "--no-autoindent" }
                            format = common.bracketed_paste_python,
                            block_deviders = { "# %%", "#%%" },
                        },
                        quarto = {
                            command = { "jupyter", "--kernel=python3" }, -- Use Jupyter console for Quarto
                            format = common.bracketed_paste_python,
                            block_deviders = { "# %%", "#%%" },
                        },
                    },
                    -- Set the file type of the newly created repl to ft
                    repl_filetype = function(_, ft)
                        return ft
                    end,
                    -- How the repl window will be displayed
                    -- repl_open_cmd = view.bottom(40),

                    -- Required _DEFAULT setting to avoid the error
                    -- Make sure there's a default open command method
                    _DEFAULT = "bottom",
                },
                -- Iron doesn't set keymaps by default anymore.
                -- You can set them here or manually add keymaps to the functions in iron.core
                keymaps = {
                    toggle_repl = "<space>rr", -- toggles the repl open and closed.
                    restart_repl = "<space>rR", -- calls `IronRestart` to restart the repl
                    send_motion = "<space>sc",
                    visual_send = "<space>sc",
                    send_file = "<space>sf",
                    send_line = "<space>sl",
                    send_paragraph = "<space>sp",
                    send_until_cursor = "<space>su",
                    send_mark = "<space>sm",
                    send_code_block = "<space>sb",
                    send_code_block_and_move = "<space>sn",
                    mark_motion = "<space>mc",
                    mark_visual = "<space>mc",
                    remove_mark = "<space>md",
                    cr = "<space>s<cr>",
                    interrupt = "<space>s<space>",
                    exit = "<space>sq",
                    clear = "<space>cl",
                },
                -- If the highlight is on, you can change how it looks
                -- For the available options, check nvim_set_hl
                highlight = {
                    italic = true,
                },
                ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
            })
        end,
    },
    {
        "GCBallesteros/NotebookNavigator.nvim",
        keys = {
            {
                "]h",
                function()
                    require("notebook-navigator").move_cell("d")
                end,
            },
            {
                "[h",
                function()
                    require("notebook-navigator").move_cell("u")
                end,
            },
            { "<leader>X", "<cmd>lua require('notebook-navigator').run_cell()<cr>" },
            { "<leader>x", "<cmd>lua require('notebook-navigator').run_and_move()<cr>" },
        },
        dependencies = {
            "echasnovski/mini.comment",
            "hkupty/iron.nvim", -- repl provider
            -- "akinsho/toggleterm.nvim", -- alternative repl provider
            -- "benlubas/molten-nvim", -- alternative repl provider
            "anuvyklack/hydra.nvim",
        },
        event = "VeryLazy",
        config = function()
            local nn = require("notebook-navigator")
            nn.setup({ activate_hydra_keys = nil })
        end,
    },
}
