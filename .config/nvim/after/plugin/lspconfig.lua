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


local function get_python_path()
    local venv_path = vim.fn.getcwd() .. "/.venv/bin/python"
    if vim.fn.executable(venv_path) == 1 then
        return venv_path
    end
    return vim.fn.exepath("python3")
end

-- Server configurations
lspconfig.pyright.setup({
    on_attach = on_attach,
    capabilities = (function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
        return capabilities
    end)(),
    settings = {
        pyright = {
            disableOrganizeImports = true, -- Using isort via null-ls
        },
        python = {
            pythonPath = get_python_path(),
            analysis = { diagnosticMode = "off", typeCheckingMode = "off" },
            -- analysis = {
            --     autoSearchPaths = true,
            --     useLibraryCodeForTypes = true,
            --     diagnosticMode = "openFilesOnly",
            -- },
        },
    },
})

lspconfig.ruff.setup({
    settings = {
        interpreter = get_python_path(),
    },
})

lspconfig.lua_ls.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                },
            },
        },
    },
})

lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
})

lspconfig.tailwindcss.setup({
    on_attach = on_attach,
})

lspconfig.docker_compose_language_service.setup({
    on_attach = on_attach,
})

lspconfig.dockerls.setup({
    on_attach = on_attach,
})

lspconfig.htmx.setup({
    on_attach = on_attach,
})

lspconfig.ansiblels.setup({
    on_attach = on_attach,
})

lspconfig.emmet_ls.setup({
    on_attach = on_attach,
})

lspconfig.bashls.setup({
    on_attach = on_attach,
})
