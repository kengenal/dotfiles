function sv --wraps='NVIM_APPNAME=nvim nvim' --wraps='NVIM_APPNAME=sql-nvim nvim' --description 'alias sv NVIM_APPNAME=sql-nvim nvim'
  NVIM_APPNAME=sql-nvim nvim $argv
        
end
