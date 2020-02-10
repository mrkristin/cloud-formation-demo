#!/bin/bash
# should really do an update, but this takes up time when doing demos
# yum update -y
mkdir /var/go
echo "created directory" >> /var/go/user-data.log
aws s3 cp  s3://mrk2019-demo/go /var/go/ --recursive
echo "copied files" >> /var/go/user-data.log
chmod 0755 /var/go/demo /var/go/start.sh
echo "changed permissions" >> /var/go/user-data.log
(crontab -l 2>/dev/null; echo "* * * * * ps -ef | grep -v grep | grep var/go/demo > /dev/null || /var/go/start.sh") | crontab -
echo "updated cron"   >> /var/go/user-data.log