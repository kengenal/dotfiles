local null_ls = require("null-ls")

null_ls.setup({

    sources = {
        -- lua
        null_ls.builtins.completion.spell,
        null_ls.builtins.diagnostics.codespell,
        null_ls.builtins.formatting.sql_formatter,
        null_ls.builtins.diagnostics.sqlfluff,
    },
})

vim.keymap.set("n", "<leader>l", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
vim.keymap.set("v", "<leader>l", function()
    vim.lsp.buf.format({
        range = {
            ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
            ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
        },
        async = true,
    })
end, { noremap = true, silent = true, desc = "Format selected text" })
