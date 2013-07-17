" compile run
"
if exists("loaded_CompileRun")
    finish
endif
let loaded_CompileRun = 1

function CompileRun()
python <<EOF

import vim
import os

vim.command(':w')
filename = vim.current.buffer.name
[filebasename , fileext] = os.path.splitext( os.path.basename(filename) )

if filebasename == 'sconstruct' and fileext == '' :
    vim.command('!scons')

elif fileext in ['.cpp','.c'] :
    if os.path.exists( 'sconstruct' ) :
        vim.command('!scons')
    elif 'cv' in '\n'.join( vim.current.buffer[0:10] ) :
        filetpl = r'''import os
import glob

cvinclude = [r'D:\OpenCV24\opencv\build\include',r'D:\OpenCV24\opencv\build\include\opencv',r'D:\OpenCV24\opencv\build\include\opencv2']

#dlibpath = r'D:\OpenCV24\opencv\build\x86\vc10\bin'
#slibpath  = r'D:\OpenCV24\opencv\build\x86\vc10\staticlib'
libpath = r'D:\OpenCV24\opencv\build\x86\vc10\lib'
cvlibs = glob.glob(libpath+os.sep+'*.lib')
cvlibs = [ os.path.splitext( os.path.basename(cvlib) )[0] for cvlib in cvlibs ]

env = Environment()
env.Program(target='%s',
            source=['%s'],
            LIBS=cvlibs,
            LIBPATH=[libpath],
            CPPPATH=cvinclude,
            )
        ''' % (filebasename,filebasename+fileext)
        open('sconstruct','w').write(filetpl)
        vim.command(':new sconstruct')
    else :
        filetpl = '''#import os',

env = Environment()
env.Program(target='%s',
            source=['%s'],
            )
        ''' % (filebasename,filebasename+fileext)
        open('sconstruct','w').write(filetpl)
        vim.command(':new sconstruct')

elif fileext == '.java' :
    vim.command('!javac %s' % filebasename+fileext)
    sym = 'applet'
    if sym in '\n'.join( vim.current.buffer[0:3] ) and not os.path.exists(filebasename+'.html'):
        tpl = '''<!DOCTYPE html>
<html>

    <head>
        <meta charset="utf-8" />
        <title>ial</title>
    </head>

    <body>

        <applet code='%s.class' height=200 width=300>
        </applet>

    </body>
    
</html>
        ''' % filebasename
        file(filebasename+'.html','w').write(tpl)
        vim.command( ':new %s' % filebasename+'.html' )

    vim.command(':set filetype=python')

elif fileext in ['.tex']:
    vim.command(':!xelatex %s' % filebasename+fileext)

EOF
endfunction

" command! Compilec call CompileC()
" nmap <silent> <Leader>tt :call AutoTpl()<CR>

" command! <leader>NN call VimPlayer()
"
"if !hasmapto('<Plug>VimPlayer')
"  nmap <silent><unique> <Leader>pp <Plug>VimPlayer
"endif
"nnoremap <unique><script> <Plug>VimPlayer:VimPlayer<CR>

