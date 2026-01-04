require("dapui").setup()
local dap, dapui = require("dap"), require("dapui")
require("nvim-dap-virtual-text").setup()
require("dap-python").setup("python")
require("dap-go").setup()

table.insert(dap.configurations.python, {
    type = "python",
    request = "launch",
    name = "Django runserver",
    program = vim.fn.getcwd() .. "/manage.py",
    args = { "runserver", "--noreload" },
    django = true,
    console = "integratedTerminal",
})

table.insert(dap.configurations.python, {
    type = "python",
    request = "launch",
    name = "Run main.py",
    program = vim.fn.getcwd() .. "/main.py",
    console = "integratedTerminal",
})

table.insert(dap.configurations.python, {
    type = "python",
    request = "launch",
    name = "Run app.py",
    program = vim.fn.getcwd() .. "/app.py",
    console = "integratedTerminal",
})

dap.configurations.go = {
    {
        type = "go",
        name = "Debug Current File",
        request = "launch",
        program = "${file}",
    },
    {
        type = "go",
        name = "Debug main.go",
        request = "launch",
        program = vim.fn.getcwd() .. "/main.go",
    },
}

dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>B", dap.run_to_cursor)

vim.keymap.set("n", "<leader>dc", function()
    dap.continue()
end)
vim.keymap.set("n", "<leader>dsi", dap.step_into)
vim.keymap.set("n", "<leader>do", dap.step_over)
vim.keymap.set("n", "<leader>dso", dap.step_out)
vim.keymap.set("n", "<leader>db", dap.step_back)
vim.keymap.set("n", "<leader>dr", dap.restart)
vim.keymap.set("n", "<leader>dx", dap.terminate)

vim.keymap.set("n", "<space>?", function()
    require("dapui").eval(nil, { enter = true })
end)
