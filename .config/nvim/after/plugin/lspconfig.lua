local lspconfig = require("lspconfig")

local opts = { noremap = true, silent = true }
local on_attach = function(client, bufnr)
    opts.buffer = bufnr
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>cn", vim.lsp.buf.rename, opts)
end
vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({0}),{0}) 

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.HINT]  = "󰠠",
            [vim.diagnostic.severity.INFO]  = "",
        },
    },
    underline = false,
    virtual_text = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        header = "",
        prefix = "",
    },
})


vim.keymap.set("n", "<leader>e", function()
    vim.diagnostic.open_float()
end, { desc = "Pokaż błąd z None LS / LSP w oknie" })


local function get_python_path()
    local venv_path = vim.fn.getcwd() .. "/.venv/bin/python"
    if vim.fn.executable(venv_path) == 1 then
        return venv_path
    end
    return vim.fn.exepath("python3")
end

-- Server configurations
lspconfig.basedpyright.setup({
    on_attach = on_attach,
    capabilities = (function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
        return capabilities
    end)(),
    settings = {
        basedpyright = {
            analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "standard",
                inlayHints = {
                    variableTypes = true,
                },
                diagnosticSeverityOverrides = {
                    reportAny = "none",
                    reportAssertAlwaysTrue = "none",
                    reportAssertTypeFailure = "none",
                    reportAssignmentToConstant = "none",
                    reportAssignmentType = "none",
                    reportAttributeAccessIssue = "none",
                    reportAugmentedAssignmentType = "none",
                    reportCallInDefaultInitializer = "none",
                    reportConstantRedefinition = "none",
                    reportDeprecated = "none",
                    reportDuplicateImport = "none",
                    reportFunctionInLoop = "none",
                    reportGeneralTypeIssues = "none",
                    reportImplicitOverride = "none",
                    reportImplicitStringConcatenation = "none",
                    reportImportCycles = "none",
                    reportIncompatibleMethodOverride = "none",
                    reportIncompatibleVariableOverride = "none",
                    reportInconsistentConstructor = "none",
                    reportInconsistentIndentation = "none",
                    reportInvalidStringEscapeSequence = "none",
                    reportInvalidStubStatement = "none",
                    reportInvalidTypeForm = "none",
                    reportInvalidTypeVarUse = "none",
                    reportMatchNotExhaustive = "none",
                    reportMissingImports = "none",
                    reportMissingModuleSource = "none",
                    reportMissingParameterType = "none",
                    reportMissingTypeArgument = "none",
                    reportMissingTypeStub = "none",
                    reportNoDefinedVariable = "none",
                    reportNonCallableObject = "none",
                    reportNonConstVariable = "none",
                    reportNotCallable = "none",
                    reportOptionalCall = "none",
                    reportOptionalContextManager = "none",
                    reportOptionalIterable = "none",
                    reportOptionalMemberAccess = "none",
                    reportOptionalOperand = "none",
                    reportOptionalSubscript = "none",
                    reportOverlappingOverload = "none",
                    reportParameterTypeNotDeclared = "none",
                    reportPrivateImportUsage = "none",
                    reportPrivateUsage = "none",
                    reportPropertyTypeMismatch = "none",
                    reportProtocolMemberMissing = "none",
                    reportRedeclaration = "none",
                    reportReturnTypeUnknown = "none",
                    reportSelfClsParameterName = "none",
                    reportShadowedImports = "none",
                    reportTypeCommentUsage = "none",
                    reportUnboundVariable = "none",
                    reportUndefinedVariable = "none",
                    reportUninitializedInstanceVariable = "none",
                    reportUnnecessaryCast = "none",
                    reportUnnecessaryComparison = "none",
                    reportUnnecessaryContains = "none",
                    reportUnnecessaryIsInstance = "none",
                    reportUnnecessaryTypeIgnore = "none",
                    reportUnreachable = "none",
                    reportUnspecifiedError = "none",
                    reportUntypedBaseClass = "none",
                    reportUntypedClassDecorator = "none",
                    reportUntypedFunctionDecorator = "none",
                    reportUntypedNamedTupleReturnType = "none",
                    reportUnusedCallResult = "none",
                    reportUnusedCoroutine = "none",
                    reportUnusedExpression = "none",
                    reportUnusedImport = "none",
                    reportUnusedVariable = "none",
                    reportUnknownArgumentType = "none",
                    reportUnknownLambdaType = "none",
                    reportUnknownMemberType = "none",
                    reportUnknownParameterType = "none",
                    reportUnknownVariableType = "none",
                    reportWildcardImportFromLibrary = "none",
                    reportAbstractUsage = "none",
                    reportAmbiguousVariableType = "none",
                    reportArgumentType = "none",
                    reportBadTypeVarUsage = "none",
                    reportBoundedTypeVarUsed = "none",
                    reportCallArgument = "none",
                    reportClassAttributeAccess = "none",
                    reportConstrainedTypeVarUsed = "none",
                    reportDefaultParameterType = "none",
                    reportFinalMethodOverride = "none",
                    reportForwardReference = "none",
                    reportFunctionMemberAccess = "none",
                    reportIncompatibleAssignment = "none",
                    reportIncompatibleAwait = "none",
                    reportIncompatibleCall = "none",
                    reportIncompatibleReturn = "none",
                    reportInvalidCast = "none",
                    reportInvalidException = "none",
                    reportInvalidMethodReturnType = "none",
                    reportInvalidOperator = "none",
                    reportInvalidTypeGuard = "none",
                    reportMissingSuperCall = "none",
                    reportNoOverloadImplementation = "none",
                    reportNonAbstractInAbstract = "none",
                    reportNonOverrideableMember = "none",
                    reportNotAccessed = "none",
                    reportOptionalExtraCheck = "none",
                    reportOverlappingUnion = "none",
                    reportPropertySetter = "none",
                    reportReadOnlyAttribute = "none",
                    reportReturnTypeMismatch = "none",
                    reportStaticMethodAccess = "none",
                    reportTypeNotStringLiteral = "none",
                    reportTypeVarUnsolvable = "none",
                    reportUnannotatedParams = "none",
                    reportUnhashableType = "none",
                    reportUnionForwardReference = "none",
                    reportUnknownType = "none",
                    reportUnpack = "none",
                    reportUnsupportedDunderAll = "none",
                    reportUnusedClass = "none",
                    reportUnusedFunction = "none",
                    reportVariableTypeNotDeclared = "none",
                    reportInvalidReturnType = "none",
                    reportMissingReturnType = "none",
                    reportIncompatibleMethodReturn = "none",
                    reportIncompatibleFunctionReturn = "none",
                    reportReturnTypeNotSpecified = "none",
                    reportOverloadedReturnType = "none",
                    reportReturnType = "none",
                    reportInvalidReturn = "none",
                    reportMissingReturn = "none",
                    reportUnexpectedReturn = "none",
                    reportReturnOutsideFunction = "none",
                    reportInconsistentReturn = "none",
                    reportReturnAnnotationMismatch = "none",
                    reportReturnTypeIncompatible = "none",
                    reportTypeMismatch = "none",
                    reportInvalidType = "none",
                    reportIncompatibleReturnType = "none",
                    reportReturnTypeExpected = "none",
                    reportReturnTypeMissing = "none",
                    reportReturnTypeInvalid = "none",
                    reportReturnTypeIncorrect = "none",
                    reportReturnTypeConflict = "none",
                    reportReturnTypeInconsistent = "none",
                    reportReturnTypeNotDeclared = "none",
                    reportReturnTypeAnnotationMissing = "none",
                    reportReturnTypeAnnotationInvalid = "none",
                    reportReturnTypeAnnotationMismatch = "none",
                    reportReturnTypeOverload = "none",
                    reportReturnTypeAmbiguous = "none",
                    reportReturnTypeUnknownInContext = "none",
                    reportReturnTypeNotAnnotated = "none",
                    reportReturnTypeNotExpected = "none",
                    reportCallIssue = "none",
                    reportInvalidTypeArguments = "none",
                },
            },
        },
        python = {
            pythonPath = ".venv/bin/python", -- Ścieżka do interpretera w .venv
            venvPath = ".venv",              -- Ścieżka do folderu środowiska wirtualnego
        },
    },
})

lspconfig.ruff.setup({
    settings = {
        interpreter = get_python_path(),
    },
})

lspconfig.lua_ls.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                },
            },
        },
    },
})

lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
})

lspconfig.tailwindcss.setup({
    on_attach = on_attach,
})

lspconfig.docker_compose_language_service.setup({
    on_attach = on_attach,
})

lspconfig.dockerls.setup({
    on_attach = on_attach,
})

lspconfig.htmx.setup({
    on_attach = on_attach,
})

lspconfig.ansiblels.setup({
    on_attach = on_attach,
})

lspconfig.emmet_ls.setup({
    on_attach = on_attach,
})

lspconfig.bashls.setup({
    on_attach = on_attach,
})
