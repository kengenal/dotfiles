return {
    -- cmd = { "djlsp --django-settings-module config.settings.base" },
    cmd = { "djlsp" },
    filetypes = { "htmldjango" },
    root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
        ".git",
    },
    settings = {

        init_options = {
            django_settings_module = "config.settings.base",
            -- docker_compose_file = "docker-compose.yml",
            -- docker_compose_service = "app"
        },
    },
}
