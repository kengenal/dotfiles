vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })

vim.keymap.set("n", "K", function()
  vim.lsp.buf.hover({
    border = "rounded",
  })
end, { desc = "Show documentation with rounded border" })
vim.diagnostic.config({
    underline = false,
    virtual_lines = true,
})


vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float({ border = "rounded" })
end, { desc = "Show error in window like hover" })


vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set("n", "gv", ":rightbelow vsplit | lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

vim.lsp.enable({"luals","bash","templ","gopls", "rust_analyzer", "basedpyright", "ruff", "htmx", "tailwindcss", "elixir_ls", "dockerls", "docker_compose_language_service"})
