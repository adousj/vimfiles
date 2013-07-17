" vim template
"
if exists("loaded_test")
    finish
endif
let loaded_test= 1

function Test()
python <<EOF

import vim
import os

#vim.command(':w')

EOF
endfunction

"command! Atpl call AutoTpl()
nmap :test :call Test()<CR>
