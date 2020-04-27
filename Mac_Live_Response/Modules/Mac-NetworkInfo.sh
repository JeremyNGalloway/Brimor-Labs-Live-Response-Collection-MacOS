#!/bin/bash

# Last updated 05 September 2019 by Brian Moran (brian@brimorlabs.com)
# Please read "ReadMe.txt" for more information regarding GPL, the script itself, and changes
# RELEASE DATE: 20190905
# AUTHOR: Brian Moran (brian@brimorlabs.com)
# TWITTER: BriMor Labs (@BriMorLabs)
# Version: Live Response Collection (Cedarpelta Build - 20190905)
# Copyright: 2013-2019, Brian Moran

# This file is part of the Live Response Collection
# The Live Response Collection is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
# Additionally, usages of all tools fall under the express license agreement stated by the tool itself.
# In the event that this tool is utilized by a company providing digital forensics/incident response services, other than BriMor Labs, without written consent from BriMor Labs, implies that the user/company agrees to pay the sum of five million dollars annually on January 1 of every year, for 10 years, to Brian Moran.


modulesource=${BASH_SOURCE[0]}
modulename=${modulesource/$modulepath/}
FILE_STDERR="${computername}/${computername}_Processing_Details.txt"
exec 2> >(tee -a "${FILE_STDERR}" >&2)


echo ""
echo -e "\n** Now running ${modulename} module **" | tee -a "${computername}/${computername}""_Processing_Details.txt"
#Netstat -an
echo -e "\nCommand Run: netstat -an" | tee -a "${computername}/${computername}""_Processing_Details.txt"
netstat -an 1>> ${computername}/LiveResponseData/NetworkInfo/netstat_current_connections.txt 
#lsof -i
echo -e "\nCommand Run: lsof -i" | tee -a "${computername}/${computername}""_Processing_Details.txt"
lsof -i 1>> ${computername}/LiveResponseData/NetworkInfo/lsof_network_connections.txt 
#scutil --dns
echo -e "\nCommand Run: scutil --dns" | tee -a "${computername}/${computername}""_Processing_Details.txt"
scutil --dns 1>> ${computername}/LiveResponseData/NetworkInfo/DNS_Configuration.txt 
#netstat -rn
echo -e "\nCommand Run: netstat -rn" | tee -a "${computername}/${computername}""_Processing_Details.txt"
netstat -rn 1>> ${computername}/LiveResponseData/NetworkInfo/Routing_table.txt 
#arp -an
echo -e "\nCommand Run: arp -an" | tee -a "${computername}/${computername}""_Processing_Details.txt"
arp -an 1>> ${computername}/LiveResponseData/NetworkInfo/ARP_table.txt 
#ifconfig -a
echo -e "\nCommand Run: ifconfig -a" | tee -a "${computername}/${computername}""_Processing_Details.txt"
ifconfig -a 1>> ${computername}/LiveResponseData/NetworkInfo/Network_interface_info.txt 
#ifconfig -L
echo -e "\nCommand Run: ifconfig -L" | tee -a "${computername}/${computername}""_Processing_Details.txt"
ifconfig -L 1>> ${computername}/LiveResponseData/NetworkInfo/Network_interface_info.txt 

# Allowed hosts
if [ -f /etc/hosts.allow ]; then
	echo -e "\nCommand Run: cat /etc/hosts.allow" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	cat /etc/hosts.allow 1>> ${computername}/LiveResponseData/NetworkInfo/Hosts_allow.txt 
else
	echo -e "\n** File /etc/hosts.allow does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
fi	

# Airport preferences file
if [ -f /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist ]; then
	echo -e "\n** Reading file com.apple.airport.preferences.plist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	defaults read /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist | sed 's:\./:$directorywherescriptrunsfrom/:g' | sed 's:.plist::g' | grep 'LastConnected' -A 9 1>> "${computername}/LiveResponseData/NetworkInfo/Wifi_Access_Points.txt" 
else
	echo -e "\n** File /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
fi	


# Firewall configuration
if [ -f /Library/Preferences/com.apple.alf.plist ]; then
	echo -e "Command Run: plutil -convert json /Library/Preferences/com.apple.alf.plist -o ${computername}/LiveResponseData/NetworkInfo/FirewallConfiguration_plist.txt" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	plutil -convert json /Library/Preferences/com.apple.alf.plist -o ${computername}/LiveResponseData/NetworkInfo/FirewallConfiguration_plist.txt 
else
	echo -e "** File /Library/Preferences/com.apple.alf.plist does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
fi	


# NAT configuration
if [ -f /Library/Preferences/SystemConfiguration/com.apple.nat.plist ]; then
	echo -e "\nCommand Run: plutil -convert json /Library/Preferences/SystemConfiguration/com.apple.nat.plist -o ${computername}/LiveResponseData/NetworkInfo/NATConfiguration_plist.txt" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	plutil -convert json /Library/Preferences/SystemConfiguration/com.apple.nat.plist -o ${computername}/LiveResponseData/NetworkInfo/NATConfiguration_plist.txt 
else
	echo -e "\n** File /Library/Preferences/SystemConfiguration/com.apple.nat.plist does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
fi	


# SMB configuration
if [ -f /Library/Preferences/SystemConfiguration/com.apple.smb.server.plist ]; then
	echo -e "\nCommand Run: plutil -convert json /Library/Preferences/SystemConfiguration/com.apple.smb.server.plist -o ${computername}/LiveResponseData/NetworkInfo/SMBConfiguration_plist.txt" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	plutil -convert json /Library/Preferences/SystemConfiguration/com.apple.smb.server.plist -o ${computername}/LiveResponseData/NetworkInfo/SMBConfiguration_plist.txt 
else
	echo -e "\n** File /Library/Preferences/SystemConfiguration/com.apple.smb.server.plist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
fi


echo ""
echo -e "** Completed running ${modulename} module **\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
echo ""
return