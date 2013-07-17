" use sjtu ftp as a git server
"
if exists("loaded_Gitsj")
    finish
endif
let loaded_gitsj = 1

function Gitsj()
python <<EOF

import vim
import os, sys
from ftplib import FTP, error_perm
#import pickle
import cPickle as pickle
import glob

import threading
import Queue
import time

cfg = {
    'host'      :   'portal.sjtu.edu.cn',
    'timeout'   :   30,
    'port'      :   21,
    'user'      :   'adousj',
    'psw'       :   'nishi..',
    'piphum'    :   1,
    'pipmax'    :   9,
    'wiki_dir'  :   '/home/adou/code/vimwiki/wiki/',
    'ftp_dir'   :   '/vimwiki/',
    }

local_file = cfg['wiki_dir']+'fct'

class Sjftp(threading.Thread):
    ''''''
    def __init__(self,queue):
        self.ftp = FTP(host=cfg['host'],user=cfg['user'],passwd=cfg['psw'],timeout=cfg['timeout'])
        #self.ftp = FTP(host=host,user=user,passwd=psw,timeout=timeout)
        self.ftp.getwelcome()
        threading.Thread.__init__(self)
        self.ftp.cwd('/')
        self.__queue = queue
        self.setDaemon(True)

    def run(self):
        while True:
            try :
                wiki,j = self.__queue.get()
                local_file = wiki
                ftp_file = cfg['ftp_dir'] + local_file[len(cfg['wiki_dir']):]
                if(j==0):   # download
                    try :
                        f = open( local_file, 'w' )
                        self.ftp.retrbinary('RETR %s'%ftp_file, f.write)
                        f.close()
                    except error_perm:
                        f.close()
                elif(j==1):     # upload
                    self.ftp.storbinary("STOR "+ftp_file, open(local_file,'rb'))
                elif(j==2) :
                    self.ftp.delete(ftp_file)
                self.__queue.task_done()
                print local_file
            except Queue.Empty:
                break

        self.ftp.quit()


# login and download the fct file, return the fct dict
def get_ftp_fct() :
    ftp = FTP(host=cfg['host'],user=cfg['user'],passwd=cfg['psw'],timeout=cfg['timeout'])
    print ftp.getwelcome()
    ftp_file = cfg['ftp_dir']+'fct'
    ftp_list = dict()
    f = open( local_file, 'w' )
    try :
        ftp.retrbinary('RETR %s'%ftp_file, f.write)
        f.close()
        ftp_list = pickle.load(open(local_file))
    except error_perm:
        f.close()
    ftp.quit()
    return ftp_list


# get local file status
def get_local_fct():
    wikis = glob.glob( cfg['wiki_dir'] + '*.wiki' )
    local_list = dict()
    for wiki in wikis :
        local_list[wiki] = os.stat(wiki).st_mtime
    return local_list


#get file need to be download, upload, delete
def get_changed_file(local_list,ftp_list):
    filelist  = { i:0 for i in ftp_list if(not i in local_list or local_list[i]<ftp_list[i]) }     # download
    for i in local_list :       # upload
        if(not i in ftp_list or local_list[i]>ftp_list[i]) :
            filelist[i] = 1
    #for i in ftp_list :
    #    if(not i in local_list) :
    #        filelist[i] = 2
    return filelist


def save_fct(local_list,ftp_list,filelist) :
    for i,j in filelist.items():
        if(j==0):
            local_list[i] = ftp_list[i]
    pickle.dump(local_list, file(local_file,'wb'))


if __name__ == '__main__' :
    ts = time.time()
    vim.command(':w')

    ftp_list = get_ftp_fct()
    local_list = get_local_fct()
    filelist = get_changed_file(local_list, ftp_list)
    if( filelist==dict() ) :
        sys.exit()

    # the last chapter
    queue = Queue.Queue(0)
    pipnum = min( len(filelist) / 5 + 1 , cfg['pipmax'])
    pipnum = 5
    for i in xrange(pipnum):
        Sjftp(queue).start()

    for i,j in filelist.items() :
        queue.put([i,j])
    save_fct(local_list, ftp_list, filelist)
    queue.put([local_file,1])

    queue.join()

    te = time.time()
    print 'total time:' ,te-ts ,'s'

EOF
endfunction


" map
nmap <silent> <leader>gs :call Gitsj()<CR>
