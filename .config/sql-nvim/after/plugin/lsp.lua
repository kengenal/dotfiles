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
