function note --wraps='NVIM_APPNAME=nvim nvim' --wraps='NVIM_APPNAME=note-nvim nvim' --description 'alias note NVIM_APPNAME=note-nvim nvim'
  NVIM_APPNAME=note-nvim nvim $argv
end

