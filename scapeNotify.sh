#!/bin/sh

# This is a bash script for a cron job to receive Scape(http://www.infoclay.com/scape/index.html) messages and updates
# To set up the cron job, put curl.sh and scapeCredential.json in /usr/bin
# Make sure curl.sh is executible, and run:
# (crontab -l ; echo "0 * * * * /bin/sh /usr/bin/curl.sh") | crontab -

# The file scapeCredential.json should have your Scape credentials in the format:
# {
# "username":"xxxx", # Your Scape login username
# "password":"xxxxxx"  # Your Scape login password
# }

SCAPE=https://scape.infoclay.com/smartscape

curl \
    -i \
    -H "Content-Type: application/json" \
    -d "@/usr/bin/scapeCredential.json" \
    ${SCAPE}/login \
> /tmp/scapeChangeLog.txt 2>&1


