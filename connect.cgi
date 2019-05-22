#!/usr/bin/python3
import subprocess
import cgi
import cgitb

# GET parameters
arguments = cgi.FieldStorage()

# Set wifi settings 
cmd = ["/usr/bin/sudo /usr/lib/cgi-bin/connect.sh " + arguments['ssid'].value + ' ' + arguments['psk'].value ]
proc = subprocess.Popen(cmd, shell=True, stdin=subprocess.PIPE)

# Print status done
print('Content-type:text/html\r\n\r\n{"status": "done"}')



