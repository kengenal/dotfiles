local function on_exit(_obj)
   vim.notify("Note save")
end

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*",
    callback = function()
        local home = vim.fn.expand("~")
        local msg = "Update note " .. os.date("%Y-%m-%d %H:%M:%S")
        vim.system({ "git", "-C", home .."/notes", "add", "." }, { text = true }, on_exit)
        vim.system({ "git", "-C", home .."/notes", "commit", "-m", msg }, { text = true }, on_exit )
        vim.system({ "git", "-C", home .."/notes", "push"}, { text = true }, on_exit )
    end,
})

