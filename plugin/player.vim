" vim template
"
if exists("loaded_player")
    finish
endif
let loaded_player = 1

function Player()
ruby<<EOF

require 'win32ole'

def play(filename)
    player = WIN32OLE.new('WMPlayer.OCX.7')
    player.OpenPlayer(filename)
end

class MusicList
end

filename = 'C:\Users\Adou\code\ruby\vimplayer\he\'s is a pirare.mp3'
play(filename)

VIM.command(':w')

EOF
endfunction

"command! Atpl call AutoTpl()
nmap <silent> <Leader>p3 :call Player()<CR>
