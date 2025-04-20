local function file_exists(name)
    local f = io.open(name, "r")
    return f ~= nil and io.close(f)
end

local function load_project_config_if_exists()
    local pth = vim.fn.expand('%:p') .. ".idea/projectconfig.lua"
    if file_exists(pth) then
        package.path = package.path .. ";" .. pth
        require("projectconfig")
    end
end

local function create_config()
    os.execute("mkdir " .. ".idea")
    local file = io.open(".idea/projectconfig.lua", "w")
    file:write([[
-- django in docker
-- python -Xfrozen_modules=off -m debugpy --listen 0.0.0.0:5555 manage.py runserver 0.0.0.0:8000
local dap = require("dap")
local port = 5678
local test_debug_port = 5555
local python = ".venv/bin/python"


require("lspconfig")["pyright"].setup {
    on_attach = function(client, bufnr)
        opts.buffer = bufnr
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>cn", vim.lsp.buf.rename, opts)
    end,
    capabilities = (function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
        return capabilities
    end)(),
    settings = {
        pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
        },
        python = {
            pythonPath = python,
            analysis = { diagnosticMode = "off", typeCheckingMode = "off" },
        },
    },
}

require("lspconfig")["ruff"].setup {
    settings = {
        interpreter = python,
    },
}


-- DOCKER

local runner = "test#python#pytest#executable"
vim.g["test#python#runner"] = "pytest"

-- python test runner type pytest, django
local test_command = "docker compose exec api pytest"
vim.g[runner] = test_command

-- FOR DOCKER
local test_debug_exe =
"docker compose exec api python -Xfrozen_modules=off -m debugpy --wait-for-client --listen 0.0.0.0:".. test_debug_port .." -m pytest"

dap.adapters.python = {
    port = port,
    host = "127.0.0.1",
    type = 'server',
}

dap.configurations.python = {
    {
        type = "python",
        connect = {
            host = "127.0.0.1", -- adres debugpy
            port = port,        -- port debugpy
        },
        request = "attach",
        justMyCode = false,
        console = "integratedTerminal",
        pathMappings = {
            {
                localRoot = vim.fn.getcwd(),
                remoteRoot = "/app",
            },
        },
    },
}

dap.listeners.after.event_initialized["docker_logs"] = function()
    local logs_command = "docker logs z2-api-1 --follow"

    vim.fn.jobstart(logs_command, {
        on_stdout = function(_, data)
            for _, line in ipairs(data) do
                require("dap.repl").append("[Docker Logs] " .. line)
            end
        end
    })
end


local function setup_debug_test()
    dap.adapters.python.port = test_debug_port
    dap.configurations.python[1].connect.port = test_debug_port
    vim.g[runner] = test_debug_exe
end

vim.keymap.set("n", "dtn", function()
    setup_debug_test()
    vim.cmd("TestNearest")
end)

vim.keymap.set("n", "dtc", function()
    setup_debug_test()
    vim.cmd("TestClass")
end)

vim.keymap.set("n", "dtl", function()
    setup_debug_test()
    vim.cmd("TestLast")
end)

vim.keymap.set("n", "dtf", function()
    setup_debug_test()
    vim.cmd("TestFile")
end)

-- ENDDOCKER

-- STANDARD
--
-- vim.g["test#python#runner"] = "pytest"
-- local runner = "test#python#pytest#executable"
-- local test_command = vim.g[runner]
--
-- local test_debug_exe = "python -Xfrozen_modules=off -m debugpy --wait-for-client --listen 127.0.0.1:".. port .." pytest"
-- dap.configurations.python = {
--   type = 'python',
--   request = 'launch',
--   name = 'Django',
--   program = vim.fn.getcwd() .. '/manage.py',  -- NOTE: Adapt path to manage.py as needed
--   args = {'runserver'},
-- }
--
-- vim.keymap.set("n", "dtn", function()
--     vim.g[runner] = test_debug_exe
--     vim.cmd("TestNearest")
-- end)
--
-- vim.keymap.set("n", "dtc", function()
--     vim.g[runner] = test_debug_exe
--     vim.cmd("TestClass")
-- end)
--
-- vim.keymap.set("n", "dtl", function()
--     vim.g[runner] = test_debug_exe
--     vim.cmd("TestLast")
-- end)
--
-- vim.keymap.set("n", "dtf", function()
--     vim.g[runner] = test_debug_exe
--     vim.cmd("TestFile")
-- end)
--
--
-- dap.listeners.after['event terminated'] = function(_, _)
--     vim.g[runner] = test_command
-- end
--
-- dap.listeners.after['event disconnected'] = function(_, _)
--     vim.g[runner] = test_command
-- end
--
--
-- ENDSTANDARD
    ]])
    file:close()
    load_project_config_if_exists()
    vim.notify("Config has been set")
end

vim.api.nvim_create_user_command('PConfigCreate', function()
    local pth = vim.fn.expand('%:p') .. ".idea/projectconfig.lua"
    if not file_exists(pth) then
        create_config()
    end
end, {})

vim.api.nvim_create_user_command('PConfig', function()
    local pth = vim.fn.expand('%:p') .. ".idea/projectconfig.lua"
    if file_exists then
        vim.cmd('e ' .. ".idea/projectconfig.lua")
    end
end, {})

load_project_config_if_exists()


vim.keymap.set('n', '<F5>', function()
  dofile('.idea/projectconfig.lua')
  vim.notify("Project config reloaded!")
end, { noremap = true, silent = true })
