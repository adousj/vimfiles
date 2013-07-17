" vim template
"
if exists("loaded_cvtcoding")
    finish
endif
let loaded_cvtcoding= 1

function CvtOneCoding()
python <<EOF

import vim
import glob

def cvt_utf8(filename):
    vim.command( ':vi %s' % filename )
    vim.command( ':set fileencoding=utf-8' )
    vim.command( ':w')
    vim.command( ':set fileencoding')
wiki = vim.current.buffer.name
cvt_utf8(wiki)
EOF
endfunction


function CvtAllCoding()
python <<EOF
import vim
import os
import glob

def cvt_utf8(files):
    vim.command( ':args %s' % files)
    vim.command( ':set fileencoding=utf-8' )
    vim.command( ':wa')
    vim.command( ':set fileencoding')
[dirname,filename] = os.path.split(vim.current.buffer.name)
cvt_utf8( dirname+os.sep+'*.wiki' )
EOF
endfunction


function CvtCoding()
python <<EOF

import vim
import os
import glob

class CvtEncoding :
    def __init__(self):
        vim.command( ':w' )
        #vim.command( ':set encoding=utf-8' )

    def to_utf8(self,filename):
        vim.command( ':vi %s' % filename )
        vim.command( ':set fileencoding=utf-8' )
        vim.command( ':set fileencoding' )
        vim.command( ':w')

    def exit(self):
        vim.command( ':wa' )
        print 'convert all file to utf-8'

[dirname,filename] = os.path.split(vim.current.buffer.name)
wikis = glob.glob( dirname + os.sep + '*.wiki' )
cvtenc = CvtEncoding()
for wiki in wikis:
    print wiki
    cvtenc.to_utf8(wiki)

cvtenc.exit()

EOF
endfunction

nmap <silent> <Leader>ee :call CvtCoding()<CR>
nmap <silent> <Leader>en :call CvtOneCoding()<CR>
nmap <silent> <Leader>aen :call CvtAllCoding()<CR>
