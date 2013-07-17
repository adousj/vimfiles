" vim template
"
if exists("loaded_autotpl")
    finish
endif
let loaded_autotpl = 1

function AutoTpl()
python <<EOF

import vim
import os

if len( vim.current.buffer ) == 1 and not vim.current.buffer[0] :
    fileext = os.path.splitext( vim.current.buffer.name )[1]
    filetpl = []
    if fileext == '.py' :
        filetpl = [
        '# !/usr/bin/python' ,
        '# coding : cp936' ,
        '# CopyRight 2012 Adou , All Rights Reserved .' ,
        '' ,
        ''
        ] 
        vim.current.buffer[:] = filetpl
        vim.current.window.cursor = (len(filetpl),0)

    if fileext == '.html' :
        filetpl = [
        '<html>' ,
        '' ,
        '<head>' ,
        '<meta charset="utf-8" />' ,
        '<title>%s</title>' % os.path.basename(vim.current.buffer.name[0:-5]) ,
        '</head>' ,
        '' ,
        '<body>' ,
        '' ,
        '' ,
        '</body>' ,
        '' ,
        '</html>'
        ] 
        vim.current.buffer[:] = filetpl
        vim.command('normal gg=G')
        vim.current.window.cursor = (9,0)

EOF
endfunction

command! Atpl call AutoTpl()
nmap <silent> <Leader>tt :call AutoTpl()<CR>

" command! <leader>NN call VimPlayer()
"
"if !hasmapto('<Plug>VimPlayer')
"  nmap <silent><unique> <Leader>pp <Plug>VimPlayer
"endif
"nnoremap <unique><script> <Plug>VimPlayer:VimPlayer<CR>

