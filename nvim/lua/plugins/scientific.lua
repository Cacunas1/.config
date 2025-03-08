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
            -- This will run after the plugin loads
            local map = vim.keymap.set

            -- Create keybindings with proper descriptions
            map("n", "<leader>mi", "<cmd>MoltenInit<CR>", { desc = "Initialize Molten kernel" })
            map("n", "<leader>mc", "<cmd>MoltenEvaluateCell<CR>", { desc = "Evaluate current cell" })
            map("n", "<leader>ml", "<cmd>MoltenEvaluateLine<CR>", { desc = "Evaluate current line" })
            map("v", "<leader>ms", ":<C-u>MoltenEvaluateVisual<CR>", { desc = "Evaluate visual selection" })
            map("n", "<leader>mr", "<cmd>MoltenReevaluateCell<CR>", { desc = "Re-evaluate current cell" })

            -- Create a cell-like experience in Python files
            map("n", "<leader>md", "<cmd>MoltenDelete<CR>", { desc = "Delete Molten cell" })
            map("n", "<leader>mh", "<cmd>MoltenHideOutput<CR>", { desc = "Hide Molten output" })
            map("n", "<leader>ms", "<cmd>MoltenShowOutput<CR>", { desc = "Show Molten output" })
        end,
        keys = {
            -- This ensures the keymaps are properly registered with which-key
            { "<leader>mi", desc = "Initialize Molten kernel" },
            { "<leader>mc", desc = "Evaluate current cell" },
            { "<leader>ml", desc = "Evaluate current line" },
            { "<leader>ms", mode = "v", desc = "Evaluate visual selection" },
            { "<leader>mr", desc = "Re-evaluate current cell" },
            { "<leader>md", desc = "Delete Molten cell" },
            { "<leader>mh", desc = "Hide Molten output" },
            { "<leader>ms", desc = "Show Molten output" },
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
            require("quarto").setup({
                -- Your Quarto configuration options here
            })
        end,
    },
}
