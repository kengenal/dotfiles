local function file_exists(name)
    local f = io.open(name, "r")
    return f ~= nil and io.close(f)
end

local function load_project_config_if_exists()
    local real_path = vim.fn.expand("%:p")
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
-- REMEMBER STOP APP COINTAINER BEFORE START DEBUG    
-- local dap = require("dap")
--
-- local config = {
--     python = {
--         debug_port = 5678,
--         test_debug_port = 5555,
--         max_retries = 240, -- 240 prób dla 2-minutowego startu
--         test_max_retries = 40,
--     },
--     docker = {
--         app = "web",
--         compose_file = "docker-compose.yml",
--         debug_entrypoint = { "manage.py", "runserver", "0.0.0.0:8000" },
--     },
--     test = {
--         runner = "pytest",
--     },
-- }
--
-- -- Konfiguracja test-runnera
-- local runner = "test#python#" .. config.test.runner .. "#executable"
-- vim.g["test#python#runner"] = config.test.runner
-- vim.g[runner] = "docker compose exec " .. config.docker.app .. " " .. config.test.runner .. " --durations=1"
--
-- -- Adapter dla aplikacji
-- dap.adapters.python = {
--     type = "server",
--     host = "0.0.0.0",
--     port = config.python.debug_port,
--     options = {
--         max_retries = config.python.max_retries,
--     },
-- }
--
-- -- Adapter dla testów
-- dap.adapters.python_test = {
--     type = "server",
--     host = "0.0.0.0",
--     port = config.python.test_debug_port,
--     options = {
--         max_retries = config.python.test_max_retries,
--     },
-- }
--
-- -- Dwie konfiguracje
-- dap.configurations.python = {
--     {
--         name = "Docker App",
--         type = "python",
--         request = "attach",
--         justMyCode = false,
--         pathMappings = {
--             { localRoot = vim.fn.getcwd(), remoteRoot = "/app" },
--         },
--     },
--     {
--         name = "Docker Tests",
--         type = "python_test",
--         request = "attach",
--         justMyCode = false,
--         pathMappings = {
--             { localRoot = vim.fn.getcwd(), remoteRoot = "/app" },
--         },
--     },
-- }
--
-- local function run_test_with_debug(test_cmd)
--     vim.g[runner] = "docker compose run --rm -p "
--         .. config.python.test_debug_port
--         .. ":"
--         .. config.python.test_debug_port
--         .. " --entrypoint='' "
--         .. config.docker.app
--         .. " python -Xfrozen_modules=off -m debugpy --wait-for-client --listen 0.0.0.0:"
--         .. config.python.test_debug_port
--         .. " -m "
--         .. config.test.runner
--
--     vim.cmd(test_cmd)
--
--     vim.defer_fn(function()
--         vim.notify("Connecting to test debugger...")
--         dap.run(dap.configurations.python[2])
--     end, 500)
-- end
--
-- vim.keymap.set("n", "dtn", function()
--     run_test_with_debug("TestNearest")
-- end)
-- vim.keymap.set("n", "dtc", function()
--     run_test_with_debug("TestClass")
-- end)
-- vim.keymap.set("n", "dtl", function()
--     run_test_with_debug("TestLast")
-- end)
-- vim.keymap.set("n", "dtf", function()
--     run_test_with_debug("TestFile")
-- end)
--
-- -- Uruchom normalnie (bez debuga)
-- local function run_compose()
--     vim.system({
--         "docker",
--         "compose",
--         "-f",
--         config.docker.compose_file,
--         "up",
--         "-d",
--         config.docker.app,
--     })
--     vim.notify("Starting app...")
-- end
--
-- local function run_compose_debug()
--     vim.notify("Starting with debugger...")
--
--     -- local debug_cmd = "pip show debugpy > /dev/null || pip install debugpy && "
--     --     .. "python -Xfrozen_modules=off -m debugpy "
--     --     .. "--listen 0.0.0.0:"
--     --     .. config.python.debug_port
--     --     .. " "
--     --     .. "--wait-for-client "
--     --     .. table.concat(config.docker.debug_entrypoint, " ")
--     local debug_cmd = "python -Xfrozen_modules=off -m debugpy "
--         .. "--listen 0.0.0.0:"
--         .. config.python.debug_port
--         .. " "
--         .. "--wait-for-client "
--         .. table.concat(config.docker.debug_entrypoint, " ")
--
--     local cmd = {
--         "docker",
--         "compose",
--         "-f",
--         config.docker.compose_file,
--         "run",
--         "-d",
--         "--rm",
--         "-p",
--         "8000:8000",
--         "-p",
--         string.format("%d:%d", config.python.debug_port, config.python.debug_port),
--         "--entrypoint=''",
--         config.docker.app,
--         "sh",
--         "-c",
--         debug_cmd,
--     }
--
--     vim.system(cmd, {}, function()
--         vim.schedule(function()
--             vim.defer_fn(function()
--                 vim.notify("Connecting debugger...")
--                 dap.run(dap.configurations.python[1])
--             end, 2000) -- Zwiększ czas bo instalacja debugpy może chwilę trwać
--         end)
--     end)
-- end
--
-- vim.keymap.set("n", "<F5>", run_compose)
-- vim.keymap.set("n", "<F6>", run_compose_debug)
    ]])
    file:close()
    load_project_config_if_exists()
    vim.notify("Config has been set")
end

vim.api.nvim_create_user_command("PConfigCreate", function()
    local pth = vim.fn.expand("%:p") .. ".idea/projectconfig.lua"
    if not file_exists(pth) then
        create_config()
    end
end, {})

vim.api.nvim_create_user_command("PConfig", function()
    local pth = vim.fn.expand("%:p") .. ".idea/projectconfig.lua"
    if file_exists then
        vim.cmd("e " .. ".idea/projectconfig.lua")
    end
end, {})

load_project_config_if_exists()

vim.keymap.set("n", "<F7>", function()
    dofile(".idea/projectconfig.lua")
    vim.notify("Project config reloaded!")
end, { noremap = true, silent = true })
