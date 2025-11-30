return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".emmyrc.json", ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_list_runtime_paths(),
                checkThirdParty = false,
            },
            codeLens = {
                enable = true,
            },
            hint = {
                enable = true,
                semicolon = "Disable",
            },
            telemetry = {
                enable = false,
            },
        },
    },
}

