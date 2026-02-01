local file_location = "~/Downloads"

-- Function to export results to CSV with file name selection
local function export_to_csv()
    vim.ui.input({
        prompt = "Enter CSV file name:",
        default = file_location .. "/results.csv",
    }, function(path)
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
            -- Skip lines containing only formatting characters, empty lines, and summary lines like "(123 rows)"
            if not line:match("^%s*[-+|]+%s*$") and line:match("%S") and not line:match("^%(%d+ rows%)$") then
                local values = vim.split(line, "|", { trimempty = true })
                local cleaned_values = {}

                for _, value in ipairs(values) do
                    local cleaned = value:match("^%s*(.-)%s*$") or ""
                    if cleaned:match('[,"]') then
                        cleaned = '"' .. cleaned:gsub('"', '""') .. '"'
                    end
                    table.insert(cleaned_values, cleaned)
                end
                table.insert(csv_lines, table.concat(cleaned_values, ","))
            end
        end

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
    vim.fn.setreg("+", json_str)
    vim.notify("Copied JSON to clipboard!", vim.log.levels.INFO)
end

local function export_to_insert_sql()
    vim.ui.input({
        prompt = "Enter SQL file name:",
        default = file_location .. "/insert.sql",
    }, function(file)
        if not file then
            return vim.notify("❌ Export canceled", vim.log.levels.WARN)
        end

        local function quote_value(v)
            if v == "" or v:lower() == "null" then
                return "NULL"
            elseif v:match("^%-?%d+$") then
                return v
            elseif v:match("^%-?%d+%.%d+$") then
                return v
            elseif v:match("^%d%d%d%d%-?%d%d%-?%d%d") then
                return "'" .. v .. "'"
            else
                return "'" .. v:gsub("'", "''") .. "'"
            end
        end

        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local headers, header_idx, out = {}, {}, {}
        for _, line in ipairs(lines) do
            if line:match("|") and not line:match("^%s*[-+]+") then
                local cols = vim.split(line, "|", { trimempty = true })
                if #headers == 0 then
                    for i, h in ipairs(cols) do
                        h = h:match("^%s*(.-)%s*$")
                        if h:lower() ~= "id" then
                            table.insert(headers, h)
                            table.insert(header_idx, i)
                        end
                    end
                    table.insert(out, "INSERT INTO table_name (" .. table.concat(headers, ", ") .. ")")
                    table.insert(out, "VALUES")
                else
                    local vals = {}
                    for _, i in ipairs(header_idx) do
                        local v = cols[i]:match("^%s*(.-)%s*$")
                        table.insert(vals, quote_value(v))
                    end
                    table.insert(out, "(" .. table.concat(vals, ", ") .. "),")
                end
            end
        end
        if #out > 0 then
            out[#out] = out[#out]:gsub(",$", ";")
            -- table.insert(out, "GO")
        end
        vim.fn.writefile(out, vim.fn.expand(file))
        vim.notify("✅ INSERT SQL saved to " .. file, vim.log.levels.INFO)
    end)
end

local function backup_database(connection)
    local scheme, rest = connection.url:match("^(.-)://(.+)$")
    if not scheme then
        return vim.notify("❌ Bad URL", vim.log.levels.ERROR)
    end
    local date = os.date("%Y%m%d")
    local db_name = rest:match(".+/([^/]+)$") or "db"
    local output_file = string.format("%s/dump_%s_%s.sql", vim.fn.expand(file_location), db_name, date)

    if scheme:match("^postgres") then
        local user, password, host, port, db = rest:match("([^:]+):([^@]+)@([^:]+):?(%d*)/(.+)")
        port = port ~= "" and port or "5432"
        if password ~= "" then
            vim.fn.system(
                string.format(
                    "PGPASSWORD='%s' pg_dump -U %s -h %s -p %s %s > %s",
                    password,
                    user,
                    host,
                    port,
                    db,
                    output_file
                )
            )
        else
            vim.fn.system(string.format("pg_dump -U %s -h %s -p %s %s > %s", user, host, port, db, output_file))
        end
        return vim.notify("✅ Backup completed successfully!\nSaved to: " .. output_file, vim.log.levels.INFO)
    end

    if scheme:match("mssql") or scheme:match("sqlserver") then
        local user, password, host, db = rest:match("([^:]+):([^@]+)@([^/]+)/(.+)")
        vim.fn.system(
            string.format("mssql-scripter -S %s -U %s -P %s -d %s > %s", host, user, password, db, output_file)
        )
        return vim.notify("✅ Backup completed successfully!\nSaved to: " .. output_file, vim.log.levels.INFO)
    end

    vim.notify("❌ Unsupported scheme", vim.log.levels.ERROR)
end

local function restore_database(connection)
    local default_path = vim.fn.expand(file_location) .. "/"
    vim.ui.input({ prompt = "Enter path to backup file: ", default = default_path, completion = "file" }, function(file)
        if not file or file == "" then
            return vim.notify("❌ No file provided", vim.log.levels.ERROR)
        end
        if vim.fn.filereadable(file) == 0 then
            return vim.notify("❌ File does not exist: " .. file, vim.log.levels.ERROR)
        end

        local scheme, rest = connection.url:match("^(.-)://(.+)$")
        if not scheme then
            return vim.notify("❌ Bad URL", vim.log.levels.ERROR)
        end

        if scheme:match("^postgres") then
            local user, password, host, port, db = rest:match("([^:]+):([^@]+)@([^:]+):?(%d*)/(.+)")
            port = port ~= "" and port or "5432"
            if password ~= "" then
                vim.fn.system(
                    string.format(
                        "PGPASSWORD='%s' psql -U %s -h %s -p %s -d %s -f %s",
                        password,
                        user,
                        host,
                        port,
                        db,
                        file
                    )
                )
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
                if not action then
                    return
                end

                local connections = vim.fn["db_ui#connections_list"]()
                local active_connections = {}
                for _, conn in ipairs(connections) do
                    if conn.is_connected == 1 then
                        table.insert(active_connections, conn)
                    end
                end
                if #active_connections == 0 then
                    return vim.notify("❌ No active connection", vim.log.levels.ERROR)
                end

                vim.ui.select(active_connections, {
                    prompt = "Select active connection:",
                    format_item = function(item)
                        return " " .. item.name
                    end,
                }, function(selected_connection)
                    if not selected_connection then
                        return
                    end

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
            callback = function()
                vim.cmd("DBUIBackupRestore")
            end,
        })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "dbout",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "gra", "", {
            noremap = true,
            silent = true,
            callback = function()
                vim.ui.select({
                    " Export to CSV (file)",
                    " Export to JSON (clipboard)",
                    " Export to INSERT SQL (file)",
                }, { prompt = "Select export format:" }, function(choice)
                    if choice == " Export to CSV (file)" then
                        export_to_csv()
                    elseif choice == " Export to JSON (clipboard)" then
                        export_to_json_to_clipboard()
                    elseif choice == " Export to INSERT SQL (file)" then
                        export_to_insert_sql()
                    end
                end)
            end,
        })
    end,
})

local ns_id = vim.api.nvim_create_namespace("dbout_sticky_header")
local sticky_enabled = {}

local function get_header_line(buf)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    for i, line in ipairs(lines) do
        if line:match("|") and not line:match("^%s*[-+]+") then
            return line, i - 1
        end
    end
    return nil, nil
end

local function update_sticky(buf, win)
    if not sticky_enabled[buf] then
        vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
        return
    end

    local header_line, header_idx = get_header_line(buf)
    if not header_line then
        return
    end

    local win_info = vim.fn.getwininfo(vim.fn.win_getid())[1]
    local leftcol = win_info.leftcol
    local win_width = win_info.width - win_info.textoff
    local cursor_row = vim.api.nvim_win_get_cursor(win)[1] - 1

    vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)

    if cursor_row > header_idx then
        local target_row = math.max(header_idx + 1, cursor_row - 4)
        local visible_header = header_line:sub(leftcol + 1, leftcol + win_width)
        vim.api.nvim_buf_set_extmark(buf, ns_id, target_row, 0, {
            virt_lines = { { { visible_header, "Normal" } } },
            virt_lines_above = true,
        })
    end
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "dbout",
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        sticky_enabled[buf] = false

        vim.api.nvim_buf_set_keymap(buf, "n", "<leader>h", "", {
            noremap = true,
            silent = true,
            desc = "Toggle sticky header",
            callback = function()
                sticky_enabled[buf] = not sticky_enabled[buf]
                if not sticky_enabled[buf] then
                    vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
                end
            end,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "WinEnter", "WinScrolled" }, {
            buffer = buf,
            callback = function()
                local win = vim.api.nvim_get_current_win()
                update_sticky(buf, win)
            end,
        })
    end,
})
