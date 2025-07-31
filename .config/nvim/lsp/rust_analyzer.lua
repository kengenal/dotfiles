return {
    cmd = { "rust-analyzer" },
    on_attach = function(client, bufnr)
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) -- Enable Rust inlay hints
    end,
    root_markers = { "Cargo.toml", ".git" },
    filetypes = { "rust" }
}
