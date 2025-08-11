return {
    cmd = { "tailwindcss-language-server", "--stdio" },
    filetypes = { "elixir", "heex", "phoenix-heex", "htmldjango" },
    root_markers = {"mix.exs", "tailwind.config.js"},
    settings = {
        tailwindCSS = {
            classAttributes = { "class", "className", "class:list" },
            includeLanguages = {
                elixir = "phoenix-heex",
                heex = "phoenix-heex"
            },
            lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidConfigPath = "error",
                invalidScreen = "error",
                invalidTailwindDirective = "error",
                invalidVariant = "error",
                recommendedVariantOrder = "warning"
            },
            validate = true
        }
    }
}
