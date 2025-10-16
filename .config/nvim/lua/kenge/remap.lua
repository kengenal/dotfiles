vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")  -- shift + j move line down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")  -- shift + k move line up

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- space + s search selected word and replace


vim.keymap.set("n", "<A-h>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-j>", ":resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", ":resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-l>", ":vertical resize +2<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

vim.keymap.set("x", "p", '"_dP')

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
vim.keymap.set('t', '<A-h>', '<C-\\><C-n><C-w>h', { noremap = true })
vim.keymap.set('t', '<A-j>', '<C-\\><C-n><C-w>j', { noremap = true })
vim.keymap.set('t', '<A-k>', '<C-\\><C-n><C-w>k', { noremap = true })
vim.keymap.set('t', '<A-l>', '<C-\\><C-n><C-w>l', { noremap = true })
