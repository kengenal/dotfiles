local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.sql_formatter,
        -- Spell check
        null_ls.builtins.completion.spell,
        null_ls.builtins.diagnostics.codespell,
    },
})

vim.keymap.set("n", "<leader>l", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
