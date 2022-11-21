#!/bin/bash
#
#  Script used to explore the network of virtual machines
#
output="whoami.txt"
count=3			# number of pings
start=11		# starting ip address
stop=15			# ending ip address
echo "STARTING $0"	 			> $output
echo "      USER: $USER"  			>> $output   
echo "      DATE: `date`" >> $output
echo "      HOST: $(hostname --ip-address)" 	>> $output
echo "Script    : $0"
echo "User      : $USER"
echo "Home      : $HOME"
echo "HOST      : $(hostname) : $(hostname --ip-address)"
echo "Date      : `date`"
echo "Directory : `pwd`"
echo "Scanning the virtual computers around us"         
echo "====================================================="
echo
echo "Scanning starting from $(hostname)"
echo "" >> $output 
echo "Scanning starting from $(hostname)" 	>> $output
echo "" 
echo "Scanning - (vma$start.cci.local ... vma$stop.cci.local)"
#
for ip in $(seq $start $stop)
do
   vmip="vma""$ip"".cci.local"
   echo -n "Scanning for vm at $vmip ..." >> $output
   echo "Use dig to find ip address for for $vmip"
   dig $vmip +noall +answer
   echo ""
   echo "Use ping to check connection with $vmip"
   ping -c $count $vmip 
   echo "Done with $vmip"
   echo ""
   echo "done with $vmip" >> $output
done   
echo "=====================================================" 
echo "" 
echo "Scanning complete from $(hostname)"
echo "" >> $output 
echo "Scanning complete from $(hostname)" 	>> $output
echo "ENDING $0"	 			>> $output
