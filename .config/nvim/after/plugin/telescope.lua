require("telescope").setup {
    defaults = {
        file_ignore_patterns = {
            "venv",
            ".venv",
            "target",
            "__pycache__",
            "node_modules",
            "dist",
        }
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                -- even more opts
            }

        }
    }
}
require("telescope").load_extension("ui-select")
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fw", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fg", builtin.git_files, {})
vim.keymap.set("n", "<leader>fs", builtin.git_status, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fm", builtin.marks, {})
vim.keymap.set("n", "<leader>a", function() 
    require('telescope.builtin').lsp_document_symbols({
      symbols = {"Method", "Function", "Class"},
      sorting_strategy = "ascending",
    })
end, {})
