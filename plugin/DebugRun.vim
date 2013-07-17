" debug c
" c cpp python ruby scheme html java php
"
if exists("loaded_DebugRun")
    finish
endif
let loaded_DebugRun = 1

function DebugRun()
python <<EOF

import vim
import os

vim.command(':w')
filename = vim.current.buffer.name
[filebasename , fileext] = os.path.splitext( os.path.basename(filename) )

defun = lambda cmd:vim.command('!'+cmd+' '+filebasename+fileext)

if fileext in ['.cpp','.c'] :
    '''
    import time
    import stat
    if ( not os.path.exists(filebasename+'.exe') ) or ( os.path.getmtime( filebasename+'.exe' ) < os.path.getmtime( filebasename+fileext ) ) :
        vim.command(':call CompileC()')
    '''
    if os.path.exists( filebasename ):
        vim.command('!./'+filebasename )
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

elif fileext == '.sh' :
    defun('bash')

elif fileext == '.py' :
    defun('python')

elif fileext == '.rb' :
    if 'Shoes.app' in ''.join(vim.current.buffer) :
        defun('shoes')
    elif 'java' in ''.join(vim.current.buffer) :
        defun('jruby')
    else :
        defun('ruby')

elif fileext == '.scm' :
    defun('mzscheme -r')

elif fileext in ['.cmd','.bat'] :
    defun('')

elif fileext in ['.tex']:
    #fileext = '.pdf'
    #defun('')
    if os.path.exists(filebasename+'.pdf'):
        vim.command(':! '+filebasename+'.pdf')
    else:
        print 'Complie first , <F7> .'

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

