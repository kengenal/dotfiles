local null_ls = require("null-ls")
local methods = require("null-ls.methods")
local h = require("null-ls.helpers")


local function ruff_format()
    return h.make_builtin({
        name = "ruff",
        meta = {
            url = "https://github.com/astral-sh/ruff",
            description = "An extremely fast Python linter, written in Rust.",
        },
        method = methods.internal.FORMATTING,
        filetypes = { "python" },
        generator_opts = {
            command = "ruff",
            args = { "format", "-s", "--stdin-filename", "$FILENAME" },
            to_stdin = true,
        },
        factory = h.formatter_factory,
    })
end

null_ls.setup({

    sources = {
        -- lua
        null_ls.builtins.formatting.stylua,

        ruff_format(),
        null_ls.builtins.formatting.djlint,
        -- null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.prettier,

        -- Spell check
        null_ls.builtins.completion.spell,

        null_ls.builtins.diagnostics.djlint,
        null_ls.builtins.diagnostics.codespell,
        -- null_ls.builtins.diagnostics.pylint,
    },
})

vim.keymap.set("n", "<leader>l", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
