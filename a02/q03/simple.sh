#!/bin/bash
#
#  Script used to print information about this computer
#
echo "STARTING $0"
echo "Script    : $0"
echo "User      : $USER"
echo "Home      : $HOME"
echo "Directory : `pwd`"
echo "Date      : `date`"
echo "==========================================="
echo
echo "Users currently logged are : " 
w | cut -d " " -f 1 - | grep -v USER | sort -u
echo
echo "This is `uname -s` running on a `uname -m` processor."
echo
echo "The system has been up for this long :`uptime`"
echo
echo "There are `ps -a | wc -l` processes running"
echo
echo "==========================================="
echo
echo "ENDING $0"

