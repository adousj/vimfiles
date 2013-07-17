
"连续按逗号然后空格快速运行Python程序
"au FileType python map <buffer> <leader><space> :w!<cr>:!python %<cr>
"快速补全
"au FileType python inoremap <buffer> $r return
"au FileType python inoremap <buffer> $s self
"au FileType python inoremap <buffer> $c ##<cr>#<space><cr>#<esc>kla
"au FileType python inoremap <buffer> $i import
"au FileType python inoremap <buffer> $p print
"inoremap <buffer> $d """<cr>"""<esc>O
"inoremap <buffer> <leader>""" """<cr>"""<esc>O
"inoremap <buffer> <leader>''' '''<cr>'''<esc>O
"inoremap <buffer> <leader>dd print 'ddd'<esc>
"imap <buffer> <leader>dd print 'ddd<esc>
"nmap <silent><unique> <leader>""" o"""<esc>
"nmap <silent><unique> <leader>''' o'''<esc>
"nmap <silent><unique> <leader>dd iprint 'ddd<esc>
"nmap <silent><unique> <leader>dd iprint 'ddd<esc>
"map <A-c> I#<esc>

"set foldmethod=indent
"set foldlevel=0
"normal zR

"au FileType python inoremap <buffer> <leader>''' '''<cr>'''<esc>O
