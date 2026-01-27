local function on_exit(obj)
    if obj.code == 0 then
        vim.notify("Note saved successfully")
    else
        vim.notify("Git error: " .. (obj.stderr or "unknown"), vim.log.levels.ERROR)
    end
end

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*",
    callback = function()
        local home = vim.fn.expand("~")
        local msg = "Update note " .. os.date("%Y-%m-%d %H:%M:%S")

        vim.system({ "git", "-C", home .. "/notes", "add", "." }, {
            text = true,
            on_exit = on_exit,
        })

        vim.system({ "git", "-C", home .. "/notes", "commit", "-m", msg }, {
            text = true,
            on_exit = on_exit,
        })

        vim.system({ "git", "-C", home .. "/notes", "push" }, {
            text = true,
            on_exit = on_exit,
        })
    end,
})
