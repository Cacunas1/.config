return {
    -- Molten (Jupyter integration)
    {
        "benlubas/molten-nvim",
        ft = { "python", "julia", "r", "quarto" },
        build = ":UpdateRemotePlugins",
        dependencies = {
            "3rd/image.nvim", -- For image support
        },
        init = function()
            -- Global settings for molten
            vim.g.molten_output_win_max_height = 12
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_wrap_output = true
        end,
        config = function()
            local map = vim.keymap.set

            -- Initialize the kernel
            map("n", "<leader>mi", "<cmd>MoltenInit<CR>", { desc = "Initialize Molten kernel" })

            -- Code cell evaluation - using text objects
            -- This creates a custom function to find and evaluate cells marked with # %%
            local function evaluate_cell()
                -- Search backwards for # %% or start of file
                local start_line = vim.fn.search([[^\s*#\s*%%]], "bnW")
                if start_line == 0 then
                    start_line = 1
                else
                    start_line = start_line + 1 -- Skip the marker line
                end

                -- Search forwards for next # %% or end of file
                local end_line = vim.fn.search([[^\s*#\s*%%]], "nW")
                if end_line == 0 then
                    end_line = vim.fn.line("$")
                else
                    end_line = end_line - 1
                end

                -- Get the lines and evaluate them
                if start_line <= end_line then
                    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
                    local code = table.concat(lines, "\n")
                    vim.cmd("MoltenEvaluateOperator")
                    vim.fn.feedkeys("V" .. (end_line - start_line + 1) .. "j", "n")
                end
            end

            -- Map the custom cell function
            map("n", "<leader>mc", evaluate_cell, { desc = "Evaluate current cell (# %% delimited)" })

            -- Standard molten commands
            map("n", "<leader>ml", "<cmd>MoltenEvaluateLine<CR>", { desc = "Evaluate current line" })
            map("v", "<leader>ms", ":<C-u>MoltenEvaluateVisual<CR>", { desc = "Evaluate visual selection" })
            map("n", "<leader>me", "<cmd>MoltenEvaluateOperator<CR>", { desc = "Evaluate with operator" })
            map("n", "<leader>md", "<cmd>MoltenDelete<CR>", { desc = "Delete Molten outputs" })
            map("n", "<leader>mh", "<cmd>MoltenHideOutput<CR>", { desc = "Hide Molten output" })
            map("n", "<leader>ms", "<cmd>MoltenShowOutput<CR>", { desc = "Show Molten output" })

            -- Additional useful mappings
            map("n", "<leader>ma", function()
                vim.cmd("MoltenInit")
                vim.cmd("sleep 100m") -- Give it a moment to initialize
                -- Import commonly used libraries in the initialized kernel
                vim.cmd(
                    [[MoltenEvaluateOperator a'import numpy as np\nimport matplotlib.pyplot as plt\nimport pandas as pd']]
                )
            end, { desc = "Initialize with common libraries" })
        end,
        keys = {
            { "<leader>mi", desc = "Initialize Molten kernel" },
            { "<leader>mc", desc = "Evaluate current cell (# %% delimited)" },
            { "<leader>ml", desc = "Evaluate current line" },
            { "<leader>ms", mode = "v", desc = "Evaluate visual selection" },
            { "<leader>me", desc = "Evaluate with operator" },
            { "<leader>md", desc = "Delete Molten outputs" },
            { "<leader>mh", desc = "Hide Molten output" },
            { "<leader>ms", desc = "Show Molten output" },
            { "<leader>ma", desc = "Initialize with common libraries" },
        },
    },

    -- Quarto configuration remains the same
    {
        "quarto-dev/quarto-nvim",
        dependencies = {
            "jmbuhr/otter.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("quarto").setup({})
        end,
    },
}
