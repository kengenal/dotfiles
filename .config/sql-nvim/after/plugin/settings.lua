vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local args = vim.fn.argv()

		if #args > 0 then
			local db_path = vim.fn.fnamemodify(args[1], ":p")
			local db_name = "Temp - " .. vim.fn.fnamemodify(args[1], ":t")

			if not vim.g.dbs then
				vim.g.dbs = {}
			end
			vim.g.dbs[db_name] = "sqlite:" .. db_path
			vim.g.db = "sqlite:" .. db_path

			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				local bufname = vim.api.nvim_buf_get_name(buf)
				if bufname == db_path then
					vim.api.nvim_buf_delete(buf, { force = true })
					break
				end
			end

			vim.schedule(function()
				vim.cmd("DBUIToggle")
				vim.cmd("normal! 2j")
				vim.cmd([[execute "normal \<CR>"]])
				vim.cmd("normal! j")
				vim.cmd([[execute "normal \<CR>"]])
			end)
		else
			vim.cmd("DBUIToggle")
		end
	end,
})

vim.g.db_ui_execute_on_save = 0
vim.g.db_ui_auto_execute_table_helpers = 1

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

vim.g.db_ui_table_helpers = {
    sqlite = {
        Select = "SELECT * FROM {table};",
        Insert = "INSERT INTO {table} () VALUES (?, ?);",
        Update = "UPDATE {table} SET column = ? WHERE id = ?;",
        Delete = "DELETE FROM {table} WHERE id = ?;",
    },
    postgresql = {
        Select = "SELECT * FROM {schema}.{table};",
        Insert = "INSERT INTO {schema}.{table} () VALUES ();",
        Update = "UPDATE {schema}.{table} SET column = $1 WHERE id = $2;",
        Delete = "DELETE FROM {schema}.{table} WHERE id = $1;",
        Constraints = "SELECT constraint_name, constraint_type FROM information_schema.table_constraints WHERE table_schema = '{schema}' AND table_name = '{table}';",
        ["Column Names"] = "SELECT string_agg(column_name, ', ' ORDER BY ordinal_position) AS columns FROM information_schema.columns WHERE table_name = '{table}';"
    },
    mssql = {
        ["Select All"] = "SELECT * FROM {schema}.{table};",
        Insert = "INSERT INTO {schema}.{table} () VALUES ();",
        Update = "UPDATE {schema}.{table} SET column = @value WHERE id = @id;",
        Delete = "DELETE FROM {schema}.{table} WHERE id = @id;",
        Constraints = "SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = '{schema}' AND TABLE_NAME = '{table}';",
        ["Column Names"] = "SELECT STRING_AGG(COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY ORDINAL_POSITION) AS columns FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '{table}';"
    }
}
