
local backup_folder = "~/Downloads"

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


local function backup_database(connection)
    local scheme, rest = connection.url:match("^(.-)://(.+)$")
    if not scheme then return vim.notify("❌ Bad URL", vim.log.levels.ERROR) end
    local date = os.date("%Y%m%d")
    local db_name = rest:match(".+/([^/]+)$") or "db"
    local output_file = string.format("%s/dump_%s_%s.sql", vim.fn.expand(backup_folder), db_name, date)

    if scheme:match("^postgres") then
        local user, password, host, port, db = rest:match("([^:]+):([^@]+)@([^:]+):?(%d*)/(.+)")
        port = port ~= "" and port or "5432"
        if password ~= "" then
            vim.fn.system(string.format("PGPASSWORD='%s' pg_dump -U %s -h %s -p %s %s > %s", password, user, host, port, db, output_file))
        else
            vim.fn.system(string.format("pg_dump -U %s -h %s -p %s %s > %s", user, host, port, db, output_file))
        end
        return vim.notify("✅ Backup completed successfully!\nSaved to: " .. output_file, vim.log.levels.INFO)
    end

    if scheme:match("mssql") or scheme:match("sqlserver") then
        local user, password, host, db = rest:match("([^:]+):([^@]+)@([^/]+)/(.+)")
        vim.fn.system(string.format("mssql-scripter -S %s -U %s -P %s -d %s > %s", host, user, password, db, output_file))
        return vim.notify("✅ Backup completed successfully!\nSaved to: " .. output_file, vim.log.levels.INFO)
    end

    vim.notify("❌ Unsupported scheme", vim.log.levels.ERROR)
end

local function restore_database(connection)
    local default_path = vim.fn.expand(backup_folder) .. "/"
    vim.ui.input({ prompt = "Enter path to backup file: ", default = default_path, completion = "file" }, function(file)
        if not file or file == "" then return vim.notify("❌ No file provided", vim.log.levels.ERROR) end
        if vim.fn.filereadable(file) == 0 then return vim.notify("❌ File does not exist: " .. file, vim.log.levels.ERROR) end

        local scheme, rest = connection.url:match("^(.-)://(.+)$")
        if not scheme then return vim.notify("❌ Bad URL", vim.log.levels.ERROR) end

        if scheme:match("^postgres") then
            local user, password, host, port, db = rest:match("([^:]+):([^@]+)@([^:]+):?(%d*)/(.+)")
            port = port ~= "" and port or "5432"
            if password ~= "" then
                vim.fn.system(string.format("PGPASSWORD='%s' psql -U %s -h %s -p %s -d %s -f %s", password, user, host, port, db, file))
            else
                vim.fn.system(string.format("psql -U %s -h %s -p %s -d %s -f %s", user, host, port, db, file))
            end
            return vim.notify("✅ Restore completed successfully from: " .. file, vim.log.levels.INFO)
        end

        if scheme:match("mssql") or scheme:match("sqlserver") then
            local user, password, host, db = rest:match("([^:]+):([^@]+)@([^/]+)/(.+)")
            vim.fn.system(string.format("sqlcmd -S %s -U %s -P %s -d %s -i %s", host, user, password, db, file))
            return vim.notify("✅ Restore completed successfully from: " .. file, vim.log.levels.INFO)
        end

        vim.notify("❌ Unsupported scheme", vim.log.levels.ERROR)
    end)
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "dbui",
    callback = function()
        vim.api.nvim_buf_create_user_command(0, "DBUIBackupRestore", function()
            vim.ui.select({ " Backup", " Restore" }, { prompt = "Select action:" }, function(action)
                if not action then return end

                local connections = vim.fn["db_ui#connections_list"]()
                local active_connections = {}
                for _, conn in ipairs(connections) do
                    if conn.is_connected == 1 then table.insert(active_connections, conn) end
                end
                if #active_connections == 0 then return vim.notify("❌ No active connection", vim.log.levels.ERROR) end

                vim.ui.select(active_connections, {
                    prompt = "Select active connection:",
                    format_item = function(item) return " " .. item.name end,
                }, function(selected_connection)
                    if not selected_connection then return end

                    if action:match("Backup") then
                        backup_database(selected_connection)
                    else
                        restore_database(selected_connection)
                    end
                end)
            end)
        end, {})

        vim.api.nvim_buf_set_keymap(0, "n", "gra", "", {
            noremap = true,
            silent = true,
            callback = function() vim.cmd("DBUIBackupRestore") end,
        })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "dbout",
    callback = function()
        vim.api.nvim_buf_create_user_command(0, "DBExportCSV", export_to_csv, {})
        vim.api.nvim_buf_create_user_command(0, "DBExportJSONToClipboard", export_to_json_to_clipboard, {})
        vim.api.nvim_buf_set_keymap(0, "n", "gra", "", {
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

