" vim template
"
if exists("loaded_gitcafevimwiki")
    finish
endif
let loaded_gitcafevimwiki= 1

function GitcafeVimwiki()
python <<EOF

import vim
import os
import time

path_html = '/media/D/ideas/vimwiki/html/vimwiki/gitcafe'

vim.command(':w')
current_dir = os.getcwd()

os.chdir(path_html)
os.system('git add .')
timestamp = time.localtime()
timestamp = time.strftime('%Y-%m-%d %H:%M:%S',timestamp)
os.system( 'git -am "%s"' % timestamp )
os.system('git push')

os.chdir(current_dir)
#vim.command(':w')

EOF
endfunction

"command! Atpl call AutoTpl()
command! GITCAFEVIMWIKI call GitcafeVimwiki()
