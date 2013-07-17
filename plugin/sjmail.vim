" vim template
"
if exists("loaded_sjmail")
    finish
endif
let loaded_sjmail= 1

function Sjmail()
python <<EOF

import vim
import sys , os
import glob
import time
import smtplib  
import mimetypes
from email.MIMEMultipart import MIMEMultipart  
from email.MIMEBase import MIMEBase  
from email.MIMEText import MIMEText  
from email.MIMEAudio import MIMEAudio  
from email.MIMEImage import MIMEImage  
from email.Encoders import encode_base64  

usr = 'adousj'
psw = 'NISHI250.0'

class SJmail :
    ''''''
    def __init__(self,usr,psw) :
        # Credentials (if needed)
        self.usr= usr
        self.psw = psw
        self.fromaddr = self.usr+'@sjtu.edu.cn'
        self.g = smtplib.SMTP('mail.sjtu.edu.cn')
        self.g.starttls()

    def send(self,mesg,files) :
        msg = MIMEMultipart()
        #msg = MIMEText(mesg,'base64','gb2312')
        msg["Subject"] = 'SJCloud'
        msg['From'] = self.fromaddr
        msg['To'] = self.fromaddr
        msg.attach(MIMEText(mesg,'plain','cp936'))  
        filenames = filter(os.path.isfile, glob.glob(files))
        for filename in filenames:  
            msg.attach(self.getAttachment(filename)) 
            print 'add' , filename
        self.g.login(self.usr,self.psw)
        print 'login sjmail as' , self.usr
        self.g.sendmail(self.fromaddr, self.fromaddr, msg.as_string())
        self.g.quit()
        print 'logout sjmail'

    def getAttachment(self,attfilename):  
        #att = MIMEText(open(attfilename,'rb').read(),'base64','gb2312')
        #basename = os.path.basename(attfilename)
        #att['Content-Type'] = 'application/octet-stream'
        #att['Content-Disposition'] = 'attachment; filename="%s"' % os.path.basename(attfilename).decode('cp936').encode('gb2312')

        att = MIMEBase('application','octet-stream')  
        att.set_payload(open(attfilename,'rb').read())  
        encode_base64(att)
        att.add_header('Content-Disposition', 'attachment; filename="%s"' % os.path.basename(attfilename).decode('mbcs').encode('cp936'))
        return att

def accessable(mesg):
    if '%nohtml' in mesg :
        return False
    else :
        return True


def main():
    ''''''
    vim.command(':w')
    #codetype = sys.getfilesystemencoding()
    ts = time.time()

    #utf2cp = lambda x : x.decode('utf-8').encode('cp936')
    #mesg = '\n'.join(vim.current.buffer)
    #mesg = mesg.decode('cp936').encode('gb2312')
    #mesg = '\n'.join(vim.current.buffer)
    filename = vim.current.buffer.name
    mesg = open(filename).read()
    filename = ''

    if accessable(mesg):
        sjmail = SJmail(usr,psw)
        sjmail.send(mesg,filename)
    else :
        print 'can not upload to mail'

    te = time.time()
    print 'Total Time:' , te-ts , 's'

main()

EOF
endfunction

"command! Atpl call AutoTpl()
nmap <silent> <Leader>ma :call Sjmail()<CR>
