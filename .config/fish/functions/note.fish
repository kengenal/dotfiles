function note --wraps='NVIM_APPNAME=nvim nvim' --wraps='NVIM_APPNAME=note-nvim nvim' --description 'alias note NVIM_APPNAME=note-nvim nvim'
  git -C ~/notes pull
  NVIM_APPNAME=note-nvim nvim ~/notes $argv
end

