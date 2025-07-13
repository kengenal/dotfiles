local lspconfig = require("lspconfig")

local opts = { noremap = true, silent = true }
local on_attach = function(client, bufnr)
    opts.buffer = bufnr
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>cn", vim.lsp.buf.rename, opts)
end
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.HINT]  = "󰠠",
            [vim.diagnostic.severity.INFO]  = "",
        },
    },
    underline = false,
    virtual_text = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        header = "",
        prefix = "",
    },
})


vim.keymap.set("n", "<leader>e", function()
    vim.diagnostic.open_float()
end, { desc = "Pokaż błąd z None LS / LSP w oknie" })
