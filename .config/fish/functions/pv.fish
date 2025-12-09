function pv --description 'Open project with nvim'
    set project (find ~/notes ~/Desktop/work ~/Desktop/python ~/Projects ~/.hyperdots ~/.dotfiles -maxdepth 1 -type d -not -path "*/.git" -not -path "*/.idea" -not -path "*/.venv" 2>/dev/null | fzf --ignore-case --preview "ls --color=always -a1 {}")
    if test -n "$project"
        cd "$project"
        set current_dir (basename (pwd))

        if test -z "$TMUX"
            if tmux ls | grep "$current_dir:"
                tmux attach-session -t "$current_dir"
            else
                tmux new-session -s "$current_dir" "fish -c 'test -d .venv; and source .venv/bin/activate.fish;v . ;exec fish'"
            end
            return
        end
        if test -d ".venv"
            source .venv/bin/activate.fish
        end
        nvim . $argv
    end
end

