local null_ls = require("null-ls")
local methods = require("null-ls.methods")
local h = require("null-ls.helpers")



null_ls.setup({
    sources = {
        null_ls.builtins.formatting.sql_formatter,
        -- Spell check
        null_ls.builtins.completion.spell,
    },
})

vim.keymap.set("n", "<leader>l", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
