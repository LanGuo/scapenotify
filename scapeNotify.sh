#!/bin/sh

# This is a bash script for a cron job to receive Scape(http://www.infoclay.com/scape/index.html) messages and updates
# To set up the cron job, put curl.sh and scapeCredential.json in the same directory 'YOURPATH'
# YOURPATH have to match the scriptPath variable in this script
# Make sure scapeNotify.sh is executible, and run:
# (crontab -l ; echo "0 * * * * /YOURPATH/scapeNotify.sh") | crontab -

# The file scapeCredential.json should have your Scape credentials in the format:
# {
# "username":"xxxx", # Your Scape login username
# "password":"xxxxxx"  # Your Scape login password
# }

SCAPE=https://scape.infoclay.com/smartscape
scriptPath=/home/languo/tmp/scapenotify

# In Ubuntu 14.04 and up, it's necessary to set the DBUS_SESSION_BUS_ADDRESS environment variable in order to use notify-send with crontab
eval "export $(egrep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME gnome-session)/environ)"

# Send POST request to Scape server and look for notifications
scapeNotification=$(
curl \
    -is \
    -H "Content-Type: application/json" \
    -d "@${scriptPath}/scapeCredential.json" \
    "${SCAPE}/login" \
| grep -oE '"notifications" :\s*[0-9]+' \
| sed 's/^.*: //'
)

# If successful, send notification about updates; if fail to get the right response, check for HTTP error message 
if [${scapeNotification} = ""]
then
	errorMessage=$(
	curl \
    	-is \
    	-H "Content-Type: application/json" \
    	-d "@${scriptPath}/scapeCredential.json" \
    	"${SCAPE}/login" \
	| grep "HTTP"
	)
	notify-send "Fail to get scape status update. Error: ${errorMessage}"
else
	notify-send "Scape new messages: ${scapeNotification}"
	# cat $scapeNotification >> /tmp/scapeChangeLog.txt 2>&1 # For debugging, log something out every time this job runs
fi


