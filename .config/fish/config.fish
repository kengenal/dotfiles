if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    pyenv init - | source
    fzf --fish | source
    # podman completion fish | source
    fzf --fish | source

    if not pgrep -x tmux > /dev/null
        if tmux has-session 2>/dev/null
            tmux attach-session -t $(tmux list-sessions -F '#{session_name}' | tail -n 1)
        else
            tmux
        end
    end

end
