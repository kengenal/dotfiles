vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })

vim.diagnostic.config({
    underline = false,
    virtual_lines = true,
})


vim.keymap.set("n", "<leader>e", function()
    vim.diagnostic.open_float()
end, { desc = "Pokaż błąd z None LS / LSP w oknie" })


vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set("n", "gv", ":rightbelow vsplit | lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

vim.lsp.enable({"rust_analyzer", "basedpyright", "ruff", "htmx", "tailwindcss", "elixir_ls", "dockerls"})
