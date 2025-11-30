local cmp = require("cmp")
local lspkind = require('lspkind')
local luasnip = require('luasnip')

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'vim-dadbod-completion' },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
        { name = "nvim_lsp_signature_help" },
        { name = "luasnip" },
    }),
    formatting = {
        format = function(entry, vim_item)
            vim_item = require("lspkind").cmp_format({
                mode = "symbol",
                maxwidth = 50,
                menu = {
                    buffer = "[Buffer]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[Snippet]",
                    nvim_lua = "[Lua]",
                    latex_symbols = "[Latex]",
                },
                symbol_map = {
                    Class = "",
                }
            })(entry, vim_item)
            if vim_item.kind == "" then
                vim_item.kind = " Table"
            end
            return vim_item
        end
    },
    sorting = {
        priority_weight = 2,
        comparators = {
            function(entry1, entry2)
                local kind_score = {
                    [cmp.lsp.CompletionItemKind.Field] = 100,
                    [cmp.lsp.CompletionItemKind.Property] = 90,
                    [cmp.lsp.CompletionItemKind.Class] = 80,
                    [cmp.lsp.CompletionItemKind.Struct] = 80,
                    [cmp.lsp.CompletionItemKind.Function] = 70,
                    [cmp.lsp.CompletionItemKind.Method] = 70,
                    [cmp.lsp.CompletionItemKind.Keyword] = 60,
                    [cmp.lsp.CompletionItemKind.Variable] = 50,
                    [cmp.lsp.CompletionItemKind.Snippet] = 40,
                }

                local kind1 = kind_score[entry1:get_kind()] or 0
                local kind2 = kind_score[entry2:get_kind()] or 0
                if kind1 ~= kind2 then
                    return kind1 > kind2
                end
            end,
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    }
})

cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
        { name = "git" },
    }, {
        { name = "buffer" },
    })
})

cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" }
    }
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" }
    }, {
        { name = "cmdline" }
    })
})
