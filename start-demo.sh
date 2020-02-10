#!/bin/bash
cd /var/go
nohup /var/go/demo &
date  >> /var/go/user.data.log
echo "^^ just started go demo via start.sh ^^" >> /var/go/user.data.log
