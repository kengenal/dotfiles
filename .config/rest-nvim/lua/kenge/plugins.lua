local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    {
        "webhooked/kanso.nvim",
        lazy = false,
        priority = 1000,
    },
    {
        "numToStr/Comment.nvim",
        opts = {
        },
        lazy = false,
    },
    "nvim-treesitter/nvim-treesitter",
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        }
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons", opt = true },
    },
    "nvim-tree/nvim-web-devicons",
    "windwp/nvim-autopairs",
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },

    --- LSP AND DIAGNOSTIGS
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
    },
    "saadparwaiz1/cmp_luasnip",
    "onsails/lspkind.nvim",
    "nvimtools/none-ls.nvim",
    --
    { "nvim-telescope/telescope-ui-select.nvim" },
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<c-h>",  "<cmd>TmuxNavigateLeft<cr>" },
            { "<c-n>",  "<cmd>TmuxNavigateDown<cr>" },
            { "<c-e>",  "<cmd>TmuxNavigateUp<cr>" },
            { "<c-i>",  "<cmd>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
        },
    },
    {
        "mistweaverco/kulala.nvim",
        ft = { "http", "rest" },
        -- opts = {
        --     -- your configuration comes here
        --     global_keymaps = false,
        --     global_keymaps_prefix = "<leader>R",
        --     kulala_keymaps_prefix = "",
        -- },
        global_keymaps = {
            ["Send request"] = { -- sets global mapping
                "<F5>",
                function() require("kulala").run() end,
                mode = { "n", "v" },  -- optional mode, default is n
                desc = "Send request" -- optional description, otherwise inferred from the key
            },
            ft = { "http", "rest" },  -- sets mapping for specified file types
            ["Send all requests"] = {
                "<leader>Ra",
                function() require("kulala").run_all() end,
                mode = { "n", "v" },
                ft = { "http", "rest" }, -- sets mapping for specified file types
            },
            ["Replay the last request"] = {
                "<leader>Rr",
                function() require("kulala").replay() end,
                ft = { "http", "rest" }, -- sets mapping for specified file types
            },
            ["Find request"] = false     -- set to false to disable
        },
    },
    -- GIT
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        }
    },
    {
        "stevearc/oil.nvim",
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        config = function()
            require("oil").setup({
                default_file_explorer = false,
                view_options = {
                    show_hidden = true,
                },
            })
        end
    },
}
local opts = {}

require("lazy").setup(plugins, opts)
