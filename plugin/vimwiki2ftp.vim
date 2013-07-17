" upload vimwiki to ftp
"
if exists("loaded_Vimwiki2Ftp")
    finish
endif
let loaded_Vimwiki2Ftp = 1

function VimwikiAll2Ftp()
python <<EOF

import vim
import os
from ftplib import FTP
import pickle

import threading
import Queue
import time

ts = time.time()

#vim.command(':w')

host = 'portal.sjtu.edu.cn'
timeout = 30
port = 21
user = 'Adousj'
psw = 'NISHI250.0'
wikipath = r'E:\ideas'
pipnum = 1
maxpipnum = 9

class Sjftp(threading.Thread):
    ''''''
    def __init__(self,queue):
        self.ftp = FTP(host=host,user=user,passwd=psw,timeout=timeout)
        self.ftp.getwelcome()
        threading.Thread.__init__(self)
        self.ftp.cwd('/')
        self.__queue = queue
        self.setDaemon(True)

    def run(self):
        while True:
            try :
                wiki = self.__queue.get()
                if wiki.startswith(wikipath):
                    ftppath = wiki[len(wikipath):].replace('\\',r'/')
                    self.ftp.storbinary("STOR "+ftppath,open(wiki,'rb'))
                self.__queue.task_done()
                print ftppath
            except Queue.Empty:
                break

        self.ftp.quit()

ftp = FTP(host=host,user=user,passwd=psw,timeout=timeout)
print ftp.getwelcome()

fctpath = os.path.join(wikipath,'vimwiki','fct')
if os.path.exists(fctpath) :
    fct = pickle.load(file(fctpath))
else :
    fct = dict()
    #pickle.dump(fct,file(fctpath,'w'))

fctlist = dict()
for root , dirs , files in os.walk(os.path.join(wikipath,'vimwiki')):
    rootftp = root[len(wikipath):].replace('\\',r'/')
    ftp.cwd('/')
    try :
        ftp.cwd(rootftp)
    except:
        ftp.cwd('/')
        ftp.mkd(rootftp)
    for f in files :
        fp = os.path.join(root,f)
        fctlist[fp] = os.stat(fp).st_mtime

ftp.quit() 

if fctpath in fctlist : del fctlist[fctpath] 
filelist = fctlist.copy()
fctlist = [ i for i in fctlist if (not i in fct) or fctlist[i]>fct[i] ]
if fctlist==dict() : os.exit(0) 

queue = Queue.Queue(0)
pipnum = min( len(fctlist) / 5 + 1 , maxpipnum )
for i in xrange(pipnum):
    Sjftp(queue).start()

for i in fctlist :
    queue.put(i)

queue.join()
pickle.dump(filelist,file(fctpath,'w'))
te = time.time()
print 'total time:' ,te-ts ,'s'
EOF
endfunction


function Vimwiki2Ftp()
python <<EOF

import vim
import os , sys
from ftplib import FTP

vim.command(':w')

host = 'portal.sjtu.edu.cn'
timeout = 30
port = 21
user = 'Adousj'
psw = 'NISHI250.0'
wikipath = r'E:/ideas'

wiki= vim.current.buffer.name
if not wiki.startswith(wikipath):
    sys.exit()
wikidir = os.path.dirname(wiki[len(wikipath):])
wikiname = os.path.basename(wiki[len(wikipath):])

ftp = FTP(host=host,user=user,passwd=psw,timeout=timeout)
print ftp.getwelcome()
ftp.cwd(wikidir)

#ftp.storbinary("STOR"+wikiname,open(wikipath+os.sep+wiki,'rb'))
ftp.storbinary("STOR "+wikiname,open(wiki,'rb'))
print wikiname , 'upload to ftp successful'

ftp.quit()
EOF
endfunction


" map
nmap <silent> <leader>aft :call VimwikiAll2Ftp()<CR>
nmap <silent> <leader>ft  :call Vimwiki2Ftp()<CR>
