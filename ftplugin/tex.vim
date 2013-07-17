" this is mostly a matter of taste. but LaTeX looks good with just a bit
" of indentation.
set sw=2

" TIP: if you write your /label's as /label{fig:something}, then if you
" type in /ref{fig: and press <C-n> you will automatically cycle through
" all the figure labels. Very useful!

set iskeyword+=:

set fileencodings=utf-8,cp936,gbk,ucs-bom,big5,euc-jp,euc-kr,latin1  

" Compile
map <F12> :call CompileRun()<cr>
imap <F12> <Esc>:call CompileRun()<cr>
" Debug
map <F11> :call DebugRun()<cr>
imap <F11> <Esc>:call DebugRun()<cr>

:inoremap | ||<ESC>i
":inoremap | <c-r>=ClosePair('|')<CR
