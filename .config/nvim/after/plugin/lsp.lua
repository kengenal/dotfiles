vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })

vim.diagnostic.config({
    underline = false,
    virtual_lines = true,
})


vim.keymap.set("n", "<leader>e", function()
    vim.diagnostic.open_float()
end, { desc = "Pokaż błąd z None LS / LSP w oknie" })




-- vim.lsp.enable("luals")
vim.lsp.enable({"rust_analyzer", "basedpyright", "ruff"})
--
-- lspconfig.tailwindcss.setup({
--     on_attach = on_attach,
-- })
--
-- lspconfig.docker_compose_language_service.setup({
--     on_attach = on_attach,
-- })
--
-- lspconfig.dockerls.setup({
--     on_attach = on_attach,
-- })
--
-- lspconfig.htmx.setup({
--     on_attach = on_attach,
-- })
--
-- lspconfig.ansiblels.setup({
--     on_attach = on_attach,
-- })
--
-- lspconfig.emmet_ls.setup({
--     on_attach = on_attach,
-- })
--
-- lspconfig.bashls.setup({
--     on_attach = on_attach,
-- })
