" git is a great tool
"
if exists("loaded_gitvimwiki")
    finish
endif
let loaded_gitvimwiki = 1

function GP()
    !cd /media/D/all/linux/vimwiki/wiki && git add *.wiki && git commit -am 'linux'
    !cd /media/D/ideas/vimwiki/wiki && git pull /media/D/all/linux/vimwiki/wiki
endfunction

function GL()
    !cd /media/D/ideas/vimwiki/wiki && git add *.wiki && git commit -am 'windows'
    !cd /media/D/all/linux/vimwiki/wiki && git pull /media/D/ideas/vimwiki/wiki
endfunction


" map
"nmap <silent> <leader>gs :call Gitsj()<CR>

map <leader>gs :GitStatus<cr>
map <leader>gc :GitCommit<cr>
"map <leader>ga :call GitAdd('~/code/vimwiki/wiki/*.wiki')<cr>
"map <leader>gp :GitPush ''<cr>
"map <leader>gl :GitPull<cr>
map <leader>gl :call GL()<cr>
map <leader>gp :call GP()<cr>
