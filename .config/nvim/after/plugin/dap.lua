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

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = "codelldb", -- zakłada że codelldb jest w PATH
        args = { "--port", "${port}" },
    },
}

dap.configurations.rust = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

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

vim.keymap.set("n", "<F6>", function()
    dap.continue()
end)

vim.keymap.set("n", "<F1>", dap.step_into, { desc = "DAP Step Into" })
vim.keymap.set("n", "<F2>", dap.step_over, { desc = "DAP Step Over" })
vim.keymap.set("n", "<F3>", dap.step_out,  { desc = "DAP Step Out" })
vim.keymap.set("n", "<F4>", dap.step_back, { desc = "DAP Step Back" })


vim.keymap.set("n", "<leader>dr", dap.restart)
vim.keymap.set("n", "<leader>dx", dap.terminate)

vim.keymap.set("n", "<space>?", function()
    require("dapui").eval(nil, { enter = true })
end)
