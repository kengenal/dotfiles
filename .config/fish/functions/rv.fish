function rv --wraps='NVIM_APPNAME=nvim nvim' --wraps='NVIM_APPNAME=rest-nvim nvim' --description 'alias rv NVIM_APPNAME=rest-nvim nvim'
  NVIM_APPNAME=rest-nvim nvim $argv
end
