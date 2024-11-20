function ls --wraps=eza --wraps='eza --icons' --wraps='eza --icons --group-directories-first' --description 'alias ls=eza --icons --group-directories-first'
  eza --icons --group-directories-first $argv
        
end
