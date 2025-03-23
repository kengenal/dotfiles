-- import mason
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

local opts = { noremap = true, silent = true }
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded"
})


-- enable mason and configure icons
mason.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})

mason_lspconfig.setup({
    -- list of servers for mason to install
    ensure_installed = {
        "ruff",
        "pyright",
        "lua_ls",
        "ts_ls",
        "ruff",
        "codespell",
        "docker_compose_language_service",
        "dockerls",
        "htmx",
        "ansiblels",
        "emmet_ls",
    },
    -- auto-install configured servers (with lspconfig)
    automatic_installation = true, -- not the same as ensure_installed
})
