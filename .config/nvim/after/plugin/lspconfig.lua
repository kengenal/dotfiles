local lspconfig = require("lspconfig")


local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

lspconfig["ts_ls"].setup {
    filetypes = {
        "javascript",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
}

-- configure lua server (with special settings)
lspconfig["lua_ls"].setup({
    settings = { -- custom settings for lua
        Lua = {
            -- make the language server recognize "vim" global
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                -- make language server aware of runtime files
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                },
            },
        },
    },
})

local opts = { noremap = true, silent = true }
local on_attach = function(client, bufnr)
    opts.buffer = bufnr
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
end


lspconfig.util.default_config = vim.tbl_extend(
    "force",
    lspconfig.util.default_config,
    {
        on_attach = on_attach,
    }
)
