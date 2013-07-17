" vim template
"
if exists("loaded_autotpl")
    finish
endif
let loaded_autotpl = 1

function AutoTpl()
    :!git
endfunction

"command! Atpl call AutoTpl()
nmap <silent> <Leader>tt :call AutoTpl()<CR>
nmap <silent> <Leader>ll :!git pull ~/code/vimwiki 