function pro --description 'Open project'
    set project (find ~/Desktop/work ~/Desktop/python ~/Projects -maxdepth 1 -type d -not -path "*/.idea" -not -path "*/.venv" | fzf --ignore-case --preview "tree -I .idea/ -I _build/ -I .venv/ -I .build/ -I target/ {}")
    if test -n "$project"
        cd "$project"
        if test -d ".venv"
            source .venv/bin/activate.fish
        end
        nvim . $argv
    end
end

