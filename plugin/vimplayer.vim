" vim player
"
if exists("loaded_vimplayer")
    finish
endif
let loaded_vimplayer = 1

function VimPlayer()
python <<EOF

import vim

framenum = 0
linenum = 40
columnnum = 80
timenum = 40

minfo = vim.current.buffer[-1].split(' ')
print minfo
i = 0
while i < len(minfo) :
    print i
    if minfo[i] == 'frame' :
        framenum = int(minfo[i+1])
        i += 2
    elif minfo[i] == 'line' :
        linenum = int(minfo[i+1])
        i += 2
    elif minfo[i] == 'column' :
        columnnum = int(minfo[i+1])
        i += 2
    elif minfo[i] == 'time' :
        timenum = int(minfo[i+1])
        i += 2
    else :
        i += 1

'''
print framenum 
print linenum 
print columnnum
print timenum
'''

vim.command( 'set nonu' )
vim.command( 'set nowrap' )
vim.command( 'set scrolloff=0' )
vim.command( 'set columns=%d' % columnnum )       
vim.command( 'set lines=%d' % linenum )          
vim.command( 'normal gg' )

for i in xrange(framenum-1) :
    #print i
    vim.command( 'execute "normal %d\<CR>zt"' % linenum )
    vim.command( 'redraw')
    vim.command( 'sleep %dm' % timenum )
   

EOF
endfunction

command! Player call VimPlayer()
nmap <silent> <Leader>mm :call VimPlayer()<CR>

" command! <leader>NN call VimPlayer()
"
"if !hasmapto('<Plug>VimPlayer')
"  nmap <silent><unique> <Leader>pp <Plug>VimPlayer
"endif
"nnoremap <unique><script> <Plug>VimPlayer:VimPlayer<CR>

