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


-- Function to export results to CSV with file name selection
local function export_to_csv()
    vim.ui.input({ prompt = "Enter CSV file name: ", default = "~/Downloads/results.csv" }, function(path)
        if not path then
            vim.notify("CSV export canceled", vim.log.levels.WARN)
            return
        end
        local expanded_path = vim.fn.expand(path)
        local dir = vim.fn.fnamemodify(expanded_path, ":h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local csv_lines = {}
        for _, line in ipairs(lines) do
            -- Skip lines containing only formatting characters (e.g., ----, +-, |)
            if not line:match("^%s*[-+|]+%s*$") and line:match("%S") then
                -- Split line by | and clean values
                local values = vim.split(line, "|", { trimempty = true })
                local cleaned_values = {}
                for _, value in ipairs(values) do
                    -- Escape quotes and wrap values containing commas or quotes
                    local cleaned = value:match("^%s*(.-)%s*$") or ""
                    if cleaned:match("[,\"]") then
                        cleaned = '"' .. cleaned:gsub('"', '""') .. '"'
                    end
                    table.insert(cleaned_values, cleaned)
                end
                table.insert(csv_lines, table.concat(cleaned_values, ","))
            end
        end
        -- Write to file
        local success = vim.fn.writefile(csv_lines, expanded_path)
        if success == 0 then
            vim.notify("Saved to " .. expanded_path, vim.log.levels.INFO)
        else
            vim.notify("Error saving to " .. expanded_path, vim.log.levels.ERROR)
        end
    end)
end

-- Function to export results to JSON and copy to clipboard
local function export_to_json_to_clipboard()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local headers = nil
    local json_data = {}
    for i, line in ipairs(lines) do
        -- Skip formatting lines (e.g., ----, +-)
        if not line:match("^%s*[-+|]+%s*$") and line:match("%S") then
            local values = vim.split(line, "|", { trimempty = true })
            -- First non-empty line is headers
            if not headers then
                headers = {}
                for _, value in ipairs(values) do
                    table.insert(headers, value:match("^%s*(.-)%s*$") or "")
                end
            else
                -- Subsequent lines are data
                local row = {}
                for j, header in ipairs(headers) do
                    row[header] = values[j] and values[j]:match("^%s*(.-)%s*$") or ""
                end
                table.insert(json_data, row)
            end
        end
    end
    local json_str = vim.fn.json_encode(json_data)
    vim.fn.setreg('+', json_str)
    vim.notify("Copied JSON to clipboard!", vim.log.levels.INFO)
end

-- Code action for dbout buffer with Nerd Fonts icons
vim.api.nvim_create_autocmd("FileType", {
    pattern = "dbout",
    callback = function()
        vim.api.nvim_buf_create_user_command(0, "DBExportCSV", export_to_csv, {})
        vim.api.nvim_buf_create_user_command(0, "DBExportJSONToClipboard", export_to_json_to_clipboard, {})
        vim.api.nvim_buf_set_keymap(0, "n", "<Leader>ca", "", {
            noremap = true,
            silent = true,
            callback = function()
                vim.ui.select(
                    {
                        " Export to CSV (file)",
                        " Export to JSON (clipboard)",
                    },
                    { prompt = "Select export format:" },
                    function(choice)
                        if choice == " Export to CSV (file)" then
                            export_to_csv()
                        elseif choice == " Export to JSON (clipboard)" then
                            export_to_json_to_clipboard()
                        end
                    end
                )
            end,
        })
    end,
})
