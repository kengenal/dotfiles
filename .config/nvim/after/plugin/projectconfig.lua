local function file_exists(name)
    local f = io.open(name, "r")
    return f ~= nil and io.close(f)
end

local function load_project_config_if_exists()
    local real_path = vim.fn.expand('%:p')
    real_path = real_path:gsub("^[^:/]+://", "")

    local pth = real_path .. ".idea/projectconfig.lua"
    
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

-- DOCKER
local dap = require("dap")

local config = {
    python = {
        path = ".venv/bin/python",
        debug_port = 5678,
        test_debug_port = 5555,
    },
    docker = {
        app = "api",
        compose_file = "docker-compose.yml",
        debug_entrypoint = {
            "python", "-Xfrozen_modules=off", "-m", "debugpy",
            "--listen", "0.0.0.0:5678", "--wait-for-client", "main.py"
        },
    },
    test = {
        runner = "pytest",
    }
}

-- DOCKER
local runner = "test#python#" .. config.test.runner .. "#executable"
vim.g["test#python#runner"] = config.test.runner
vim.g[runner] = "docker compose exec " .. config.docker.app .. " " .. config.test.runner .. " --durations=1"

dap.adapters.python = {
    port = config.python.debug_port,
    host = "127.0.0.1",
    type = 'server',
}

dap.configurations.python = {
    {
        type = "python",
        connect = {
            host = "127.0.0.1",
            port = config.python.debug_port,
        },
        request = "attach",
        justMyCode = false,
        console = "integratedTerminal",
        pathMappings = {
            {
                localRoot = vim.fn.getcwd(), -- Ścieżka w Neovimie
                remoteRoot = "/app",         -- Ścieżka na serwerze
            },
        },
    },
}

dap.listeners.after.event_initialized["docker_logs"] = function()
    local logs_command = "docker compose logs " .. config.docker.app .. " -f"

    vim.fn.jobstart(logs_command, {
        on_stdout = function(_, data)
            for _, line in ipairs(data) do
                require("dap.repl").append("[Docker Logs] " .. line)
            end
        end
    })
end

local function setup_debug_test()
    dap.adapters.python.port = config.python.test_debug_port
    dap.configurations.python[1].connect.port = config.python.test_debug_port
    vim.g[runner] = "docker compose exec " .. config.docker.app ..
        " python -Xfrozen_modules=off -m debugpy --wait-for-client --listen 0.0.0.0:" ..
        config.python.test_debug_port .. " -m " .. config.test.runner
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

local function run_compose()
    vim.system({
        "docker", "compose", "-f", config.docker.compose_file,
        "up", "-d", "--force-recreate", config.docker.app
    })
    vim.cmd("normal! <F7>")
    vim.notify("Start app")
end

local function run_compose_debug()
    vim.system({
        "docker", "compose", "-f", config.docker.compose_file,
        "run", "-d", "--rm",
        "--entrypoint", table.concat(config.docker.debug_entrypoint, " "),
        "-p", string.format("%d:%d", config.python.debug_port, config.python.debug_port),
        config.docker.app
    })

    vim.cmd("Neotree close")
    require("dap").continue()
end

vim.keymap.set("n", "<F5>", run_compose)
vim.keymap.set("n", "<F6>", run_compose_debug)

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


vim.keymap.set('n', '<F7>', function()
  dofile('.idea/projectconfig.lua')
  vim.notify("Project config reloaded!")
end, { noremap = true, silent = true })
