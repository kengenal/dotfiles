require("kulala").setup {

    ft = { "http", "rest" },
    global_keymaps = {
        ["Send request"] = { -- sets global mapping
            "<F5>",
            function() require("kulala").run() end,
            mode = { "n", "v" },  -- optional mode, default is n
            desc = "Send request" -- optional description, otherwise inferred from the key
        },
        ft = { "http", "rest" },  -- sets mapping for specified file types
        ["Send all requests"] = {
            "<leader>Ra",
            function() require("kulala").run_all() end,
            mode = { "n", "v" },
            ft = { "http", "rest" }, -- sets mapping for specified file types
        },
        ["Replay the last request"] = {
            "<leader>Rr",
            function() require("kulala").replay() end,
            ft = { "http", "rest" }, -- sets mapping for specified file types
        },
        ["Find request"] = false     -- set to false to disable
    },
    lsp = {
        keymaps = {
            ["K"] = { vim.lsp.buf.hover, desc = "Hover" },
            ["<leader>ca"] = { vim.lsp.buf.code_action, desc = "Code Action" },
        }
    }
}
