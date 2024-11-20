if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    pyenv init - | source
    fzf --fish | source
    podman completion fish | source
end
# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
