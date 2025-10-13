vim.keymap.set("n", "<leader>tn", function()
    vim.cmd("TestNearest")
end)

vim.keymap.set("n", "<leader>tc", function()
    vim.cmd("TestClass")
end)

vim.keymap.set("n", "<leader>tl", function()
    vim.cmd("TestLast")
end)

vim.keymap.set("n", "<leader>tf", function()
    vim.cmd("TestFile")
end)

vim.keymap.set("n", "<leader>ts", function()
    vim.cmd("TestStratego")
end)
-- vim.cmd("let test#strategy = 'neovim_sticky'")
--
-- vim.g["test#neovim#term_position"] = "vert botright "

vim.g["test#custom_strategies"] = {
    custom_tmux = function(cmd)
        local panes = vim.fn.systemlist("tmux list-panes -F '#{pane_index}'")
        local target_pane_index = 2
        if #panes == 3 then
            target_pane_index = 3
        end

        local pane_exists = vim.fn.system("tmux list-panes -F '#{pane_index}' | grep '^" .. target_pane_index .. "$'")
        if pane_exists == "" then
            vim.fn.system("tmux split-window -h")
            vim.fn.system("tmux resize-pane -t " .. target_pane_index .. " -x 75")
            vim.fn.system("tmux select-pane -t 1")
        end

        vim.fn.system("tmux send-keys -t " .. target_pane_index .. " 'clear' C-m")
        vim.fn.system(string.format("tmux send-keys -t %d '%s' C-m", target_pane_index, cmd))
    end
}


-- local END_MARKER = "|O|"
-- local ns_id = vim.api.nvim_create_namespace("test_virtual_text")
--
-- local function trim(s)
--     if not s then return "" end
--     return (s:gsub("^%s+", ""):gsub("%s+$", ""))
-- end
--
-- local function parse_elixir(bufnr, output)
--     local failed, excluded, passed = {}, {}, {}
--
--     for _, line in ipairs(output) do
--         local test_name, status = line:match("%* test ([^%(]+)%s*%(([^%)]+)%)")
--         if test_name and status == "excluded" then
--             excluded[trim(test_name)] = true
--         end
--
--         local fail_name = line:match("%d+%)%s+test%s+([^(]+)")
--         if fail_name then
--             failed[trim(fail_name)] = true
--         end
--
--         local raw_name = line:match("%* test ([^%[]+)")
--         if raw_name then
--             raw_name = trim(raw_name)
--             raw_name = raw_name:gsub("%s*%([^%)]+%)$", "")
--             if not raw_name:find("excluded") and not failed[raw_name] and not excluded[raw_name] then
--                 passed[raw_name] = true
--             end
--         end
--     end
--
--     return failed, {}, passed
-- end
--
-- local function parse_pytest(bufnr, output)
--     local failed, passed = {}, {}
--
--     for _, line in ipairs(output or {}) do
--         if type(line) ~= "string" or line == "" then goto continue end
--
--         local test_name_passed = line:match("([^%s]+)%s+PASSED%s*.*")
--         local test_name_failed = line:match("([^%s]+)%s+FAILED")
--         -- print(vim.inspect(test_name_passed))
--
--         if test_name_passed then
--             local method_name = test_name_passed:match(".*%:%:([^%s]+)")
--             if method_name then
--                 passed[trim(method_name)] = true
--             end
--         end
--
--         if test_name_failed then
--             local method_name = test_name_failed:match(".*%:%:([^%s]+)")
--             if method_name and not passed[trim(method_name)] then
--                 failed[trim(method_name)] = true
--             end
--         end
--
--         ::continue::
--     end
--
--     return failed, {}, passed
-- end
--
-- local function update_virtual_text(bufnr, failed, excluded, passed)
--     local line_count = vim.api.nvim_buf_line_count(bufnr)
--
--     local existing_marks = vim.api.nvim_buf_get_extmarks(bufnr, ns_id, 0, -1, { details = true })
--     local existing_map = {}
--     for _, mark in ipairs(existing_marks) do
--         local mark_id, line, _, details = mark[1], mark[2], mark[3], mark[4]
--         if details and details.virt_text then
--             existing_map[line] = { id = mark_id, virt_text = details.virt_text }
--         end
--     end
--
--     for lnum = 1, line_count do
--         local line_text = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1]
--         if not line_text then goto continue end
--
--         local test_name = line_text:match('def%s+([_%w]+)') or line_text:match('test%s+"([^"]+)"')
--         if test_name then
--             test_name = trim(test_name)
--
--             local virt_text
--             if failed[test_name] then
--                 virt_text = { { "✗ Test failed", "DiagnosticError" } }
--             elseif excluded and excluded[test_name] then
--                 virt_text = { { "↷ Test excluded", "DiagnosticWarn" } }
--             elseif passed and passed[test_name] then
--                 virt_text = { { "✓ Test passed", "DiagnosticOk" } }
--             end
--             if not virt_text then 
--                 ::continue::
--             end
--
--                 local existing = existing_map[lnum - 1]
--                 if existing then
--                     local old_text = existing.virt_text[1] and existing.virt_text[1][1] or ""
--                     if old_text ~= virt_text[1][1] then
--                         vim.api.nvim_buf_set_extmark(bufnr, ns_id, lnum - 1, -1, {
--                             id = existing.id,
--                             virt_text = virt_text,
--                             virt_text_pos = "eol",
--                             hl_mode = "combine",
--                         })
--                     end
--                 else
--                     vim.api.nvim_buf_set_extmark(bufnr, ns_id, lnum - 1, -1, {
--                         virt_text = virt_text,
--                         virt_text_pos = "eol",
--                         hl_mode = "combine",
--                     })
--                 end
--         end
--         ::continue::
--     end
-- end
--
-- vim.g["test#custom_strategies"] = {
--     custom_tmux = function(cmd)
--         local bufnr = vim.api.nvim_get_current_buf()
--         local filetype = vim.bo[bufnr].filetype
--
--         if filetype == "elixir" and not cmd:match("%-%-trace") then
--             cmd = cmd .. " --trace"
--         end
--
--         if filetype == "python" and not cmd:match("%-vv") then
--             cmd = cmd .. " -vv"
--         end
--
--         local panes = vim.fn.systemlist("tmux list-panes -F '#{pane_index}'")
--         local target_pane_index = (#panes == 3) and 3 or 2
--
--         local pane_exists = vim.fn.system("tmux list-panes -F '#{pane_index}' | grep '^" .. target_pane_index .. "$'")
--         if pane_exists == "" then
--             vim.fn.system("tmux split-window -h")
--             vim.fn.system("tmux resize-pane -t " .. target_pane_index .. " -x 75")
--             vim.fn.system("tmux select-pane -t 1")
--         end
--
--         vim.fn.system("tmux send-keys -t " .. target_pane_index .. " 'clear && printf \"\\e[3J\"' C-m")
--         vim.fn.system(string.format(
--             "tmux send-keys -t %d '%s; echo \"%s\"' C-m",
--             target_pane_index,
--             cmd,
--             END_MARKER
--         ))
--
--         local timer = vim.loop.new_timer()
--         local timeout_ms = 2 * 60 * 1000 -- 2 minutes
--
--         local function stop_and_parse(output)
--             if timer then
--                 timer:stop()
--                 timer:close()
--                 timer = nil
--             end
--
--             local failed, excluded, passed
--             if filetype == "elixir" then
--                 failed, excluded, passed = parse_elixir(bufnr, output)
--             elseif filetype == "python" then
--                 failed, excluded, passed = parse_pytest(bufnr, output)
--             else
--                 failed, excluded, passed = {}, {}, {}
--             end
--             update_virtual_text(bufnr, failed, excluded, passed)
--         end
--
--         timer:start(0, 1000, vim.schedule_wrap(function()
--             output = vim.fn.systemlist("tmux capture-pane -pt " .. target_pane_index .. " -S - -E -")
--             for _, line in ipairs(output) do
--                 local end_marker = vim.pesc(END_MARKER)
--                 if line:find(end_marker) and not line:find("echo") then
--                     stop_and_parse(output)
--                     break
--                 end
--             end
--         end))
--
--         vim.defer_fn(function()
--             if timer then
--                 timer:stop()
--                 timer:close()
--                 timer = nil
--             end
--         end, timeout_ms)
--     end,
-- }
-- vim.g["test#strategy"] = "custom_tmux"       
-- vim.g["test#strategy"] = "neovim"       
