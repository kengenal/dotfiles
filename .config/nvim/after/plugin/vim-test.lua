vim.keymap.set("n", "tn", function()
    vim.cmd("TestNearest")
end)

vim.keymap.set("n", "tc", function()
    vim.cmd("TestClass")
end)

vim.keymap.set("n", "tl", function()
    vim.cmd("TestLast")
end)

vim.keymap.set("n", "tf", function()
    vim.cmd("TestFile")
end)

vim.keymap.set("n", "ts", function()
    vim.cmd("TestStratego")
end)
-- vim.cmd("let test#strategy = 'neovim_sticky'")
--
-- vim.g["test#neovim#term_position"] = "vert botright "


vim.g["test#custom_strategies"] = {
    custom_tmux = function(cmd)
        local target_pane_index = 2
        local pane_exists = vim.fn.system("tmux list-panes -F '#{pane_index}' | grep '^" .. target_pane_index .. "'")
        if pane_exists == "" then
            vim.fn.system("tmux split-window -h")
            vim.fn.system("tmux resize-pane -t 2 -x 75")
            vim.fn.system("tmux select-pane -t 1")
        end
        vim.fn.system("tmux send-keys -t " .. target_pane_index .. " 'clear' C-m")

        vim.fn.system(string.format("tmux send-keys -t %d '%s' C-m", target_pane_index, cmd))
    end
}

vim.g["test#strategy"] = "custom_tmux"
