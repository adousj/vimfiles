" vim template
"
if exists("loaded_others")
    finish
endif
let loaded_others = 1

function TimeTag()
python <<EOF

import vim
import os , sys
import time

#vim.command(':w')

today = time.localtime()
today = time.strftime('%Y-%m-%d %H:%M:%S',today)

x, y = vim.current.window.cursor
x = max(x-1,0)
vim.current.buffer[x] = vim.current.buffer[x][:y] + today + vim.current.buffer[x][y:]
#vim.current.window.cursor = (len(filetpl),0)

#vim.command(':w')

EOF
endfunction

"command! Atpl call TimeTag()
nmap <silent> <Leader>da :call TimeTag()<CR>

" command! <leader>NN call VimPlayer()
"
"if !hasmapto('<Plug>VimPlayer')
"  nmap <silent><unique> <Leader>pp <Plug>VimPlayer
"endif
"nnoremap <unique><script> <Plug>VimPlayer:VimPlayer<CR>
