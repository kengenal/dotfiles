-- CTL + SHITFT + o  -  fuzzy finder
-- CTL + SHITFT + s -  fuzzy finder, search by string using grep
-- CTL + SHITFT + s -  fuzzy finder, search git files
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- space + p + v go back to file explorer

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")  -- shift + j move line down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")  -- shift + k move line up

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- space + s search selected word and replace


vim.keymap.set("n", "<A-h>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-j>", ":resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", ":resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-l>", ":vertical resize +2<CR>", { noremap = true, silent = true })


vim.keymap.set("x", "p", '"_dP')
