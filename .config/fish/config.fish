if status is-interactive
    # Commands to run in interactive sessions can go here

    starship init fish | source

    pyenv init - | source
    fzf --fish | source


    set -gx EDITOR nvim
    set -gx VISUAL nvim

end



# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/lukaszsebastianski/.lmstudio/bin
# End of LM Studio CLI section

