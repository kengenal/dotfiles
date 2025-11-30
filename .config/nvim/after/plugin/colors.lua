-- -- Default options
-- require('nightfox').setup({
--   options = {
--     compile_path = vim.fn.stdpath("cache") .. "/nightfox",
--     compile_file_suffix = "_compiled", -- Compiled file suffix
--     transparent = true,     -- Disable setting background
--     terminal_colors = true,  -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
--     dim_inactive = false,    -- Non focused panes set to alternative background
--     module_default = true,   -- Default enable value for modules
--     colorblind = {
--       enable = false,        -- Enable colorblind support
--       simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
--       severity = {
--         protan = 0,          -- Severity [0,1] for protan (red)
--         deutan = 0,          -- Severity [0,1] for deutan (green)
--         tritan = 0,          -- Severity [0,1] for tritan (blue)
--       },
--     },
--     styles = {               -- Style to be applied to different syntax groups
--       comments = "italic",
--       keywords = "bold",
--       types = "italic,bold",
--     },
--     inverse = {             -- Inverse highlight for different types
--       match_paren = false,
--       visual = false,
--       search = false,
--     },
--     modules = {             -- List of various plugins and additional options
--     },
--   },
--   palettes = {},
--   specs = {},
--   groups = {},
-- })
--
-- -- setup must be called before loading
-- vim.cmd("colorscheme terafox")
--
-- All builtin colorschemes can be accessed with |:colorscheme|.
vim.cmd('colorscheme base16-black-metal-burzum')

-- Alternatively, you can provide a table specifying your colors to the setup function.
-- require('base16-colorscheme').setup({
--     base00 = '#16161D', base01 = '#2c313c', base02 = '#3e4451', base03 = '#6c7891',
--     base04 = '#565c64', base05 = '#abb2bf', base06 = '#9a9bb3', base07 = '#c5c8e6',
--     base08 = '#e06c75', base09 = '#d19a66', base0A = '#e5c07b', base0B = '#98c379',
--     base0C = '#56b6c2', base0D = '#0184bc', base0E = '#c678dd', base0F = '#a06949',
-- })
--
require('base16-colorscheme').with_config({
    telescope = false,
    indentblankline = false,
    notify = true,
    ts_rainbow = false,
    cmp = false,
    illuminate = false,
    dapui = false,
})

-- vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
-- vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })


-- TRANSPARENT
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
-- vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
-- vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
-- vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none" })
-- vim.api.nvim_set_hl(0, "LineNrAbove", { bg = "none" })
-- vim.api.nvim_set_hl(0, "LineNrBelow", { bg = "none" })
-- vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
-- vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" })
-- vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
-- vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
-- vim.api.nvim_set_hl(0, "MsgArea", { bg = "none" })
-- vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
-- vim.api.nvim_set_hl(0, "PmenuSel", { bg = "none" })
-- vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "none" })
-- vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "none" })
vim.api.nvim_set_hl(0, "CmpPmenu", { bg = "none" })
vim.api.nvim_set_hl(0, "CmpItemAbbr", { bg = "none" })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "none" })
vim.api.nvim_set_hl(0, "CmpItemKind", { bg = "none" })
vim.api.nvim_set_hl(0, "CmpItemMenu", { bg = "none" })
-- vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
-- vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none" })
-- vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "none" })
-- vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "none" })
--
