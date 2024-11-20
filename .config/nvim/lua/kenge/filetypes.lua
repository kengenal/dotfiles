local ansiblePlaybookGroup = vim.api.nvim_create_augroup("AnsiblePlaybook", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*-playbook.yml",
    callback = function()
        vim.bo.filetype = "yaml.ansible"
    end,
    group = ansiblePlaybookGroup,
})


local dockerComposeGroup = vim.api.nvim_create_augroup("DockerCompose", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "docker-compose.yml", "docker-compose.*.yml", "dev.yml" },
    callback = function()
        vim.bo.filetype = "yaml.docker-compose"
        vim.b.docker_compose = true
    end,
    group = dockerComposeGroup,
})
