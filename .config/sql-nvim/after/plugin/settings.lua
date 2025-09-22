vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("DBUI")
  end
})


-- Optional: Disable auto-execution on save
vim.g.db_ui_execute_on_save = 0

-- Mappings for SQL buffers
vim.api.nvim_create_autocmd("FileType", {
    pattern = "sql",
    callback = function()
        -- Map <F5> to execute query in normal and visual modes
        vim.api.nvim_buf_set_keymap(0, "n", "<F5>", "<Plug>(DBUI_ExecuteQuery)", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(0, "v", "<F5>", "<Plug>(DBUI_ExecuteQuery)", { noremap = true, silent = true })
        -- Map :w to save the query permanently (no execution)
        vim.api.nvim_buf_set_keymap(0, "n", ":w<CR>", ":w<CR><Plug>(DBUI_SaveQuery)", { noremap = true, silent = true })
    end,
})


vim.api.nvim_create_autocmd("FileType", {
    pattern = "dbout",
    callback = function()
        local opts = { noremap = true, silent = true, buffer = 0 }

        -- toggle layout do <Leader>L
        vim.keymap.set("n", "<Leader>l", "<Plug>(DBUI_ToggleResultLayout)", opts)

        -- Yank value pod kursorem (domyślnie yic)
        vim.keymap.set("n", "<Leader>y", "yic", opts)

        -- Jump to foreign key (domyślnie <C-]>)
        vim.keymap.set("n", "gd", "<Plug>(DBUI_JumpToForeignKey)", opts)

        -- Populate last query (domyślnie r)
        vim.keymap.set("n", "<Leader>r", "r", opts)

        -- Edit bind parameters
        vim.keymap.set("n", "<Leader>E", "<Plug>(DBUI_EditBindParameters)", opts)
    end,
})

