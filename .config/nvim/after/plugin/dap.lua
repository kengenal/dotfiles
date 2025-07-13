require("dapui").setup()
local dap, dapui = require("dap"), require("dapui")
require("nvim-dap-virtual-text").setup()
require("dap-python").setup("python")

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
    vim.cmd("Neotree close")
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
