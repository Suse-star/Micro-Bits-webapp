import os
from pathlib import Path
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import json
from email.header import Header
from email.utils import formataddr 

def sendWarning(what, level, microbit, receiver_address):
    mail_content = '''
    ---------------------------------------------------------------------------------------
    This is an autogenerated mail from the Microbit-Monitoring System
    =================================================
    Do not reply
    ---------------------------------------------------------------------------------------
    '''
    #The mail addresses and password
    with open(os.path.join(Path(__file__).parent.absolute(), 'cred.json')) as json_file:
        data = json.load(json_file)

    sender_address = data['e-mail']
    sender = formataddr((str(Header(data['name'])), sender_address))
    sender_pass = data['password']
    #Setup the MIME
    message = MIMEMultipart()
    message['From'] = sender

    message['To'] = receiver_address
    name = 'gozip'
    what = 'temperature'
    level = 'higher'
    message['Subject'] = 'System Warning: {} is {} than allowed interval on microbit: {}.'.format(what, level, name)   #The subject line
    message.attach(MIMEText(mail_content, 'plain'))
    #Create SMTP session for sending the mail
    try:
        session = smtplib.SMTP('smtp.gmail.com', data['port'])
    except:
        print('Not able to send e-mail')
        return False
    session.starttls() #enable security
    session.login(sender_address, sender_pass) #login with mail_id and password
    text = message.as_string()
    session.sendmail(sender, receiver_address, text)
    session.quit()
    print('Warning sent to {}'.format(receiver_address))
    return True