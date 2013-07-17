" ScriptTest
if exists("loaded_ScriptTest")
    finish
endif
let loaded_ScriptTest= 1

function Getfolder()
    return g::vimwiki_list[0]['path_html']
endfunction

function ScriptTest()
python <<EOF

import vim
import os

#vim.command(':w')
filename = vim.current.buffer.name
#[filebasename , fileext] = os.path.splitext( os.path.basename(filename) )

#print Getfolder()
vim.command(':call Getfolder()')

#vim.command(":echo g:vimwiki_list[0]['path_html']")

'''
defun = lambda cmd:vim.command('!'+cmd+' '+filebasename+fileext)

if fileext in ['.cpp','.c'] :
    import time
    import stat
    if ( not os.path.exists(filebasename+'.exe') ) or ( os.path.getmtime( filebasename+'.exe' ) < os.path.getmtime( filebasename+fileext ) ) :
        vim.command(':call CompileC()')
    if os.path.exists( filebasename+'.exe' ):
        vim.command('!'+filebasename+'.exe')
    else :
        print 'Complie first , <F7> .'

elif fileext in ['.html','.htm'] :
    import webbrowser
    webbrowser.open_new_tab(filename)

elif fileext == '.java' :
    sym = 'applet'
    if sym in '\n'.join( vim.current.buffer[0:3] ) : 
        if os.path.exists( filebasename+'.html' ):
            vim.command('!appletviewer %s' % (filebasename+'.html') ) 
        else :
            print 'Complie first , <F7> .'
    elif os.path.exists(filebasename+'.class') :
        vim.command( '!java %s' % filebasename )

elif fileext == '.php' :
    defun('php')
'''

EOF
endfunction

"command! Compilec call CompileC()
" nmap <silent> <Leader>tt :call AutoTpl()<CR>

" command! <leader>NN call VimPlayer()
"
"if !hasmapto('<Plug>VimPlayer')
"  nmap <silent><unique> <Leader>pp <Plug>VimPlayer
"endif
"nnoremap <unique><script> <Plug>VimPlayer:VimPlayer<CR>

