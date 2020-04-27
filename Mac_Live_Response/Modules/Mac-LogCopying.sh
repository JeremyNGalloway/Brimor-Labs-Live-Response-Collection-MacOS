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


#Making directories
echo -e "\nCommand Run: mkdir -p ${computername}/LiveResponseData/CopiedFiles/Logs" | tee -a "${computername}/${computername}""_Processing_Details.txt"
mkdir -p ${computername}/LiveResponseData/CopiedFiles/Logs
echo -e "\nCommand Run: mkdir -p ${computername}/LiveResponseData/CopiedFiles/Logs/var" | tee -a "${computername}/${computername}""_Processing_Details.txt"
mkdir -p ${computername}/LiveResponseData/CopiedFiles/Logs/var
#Redundant (keeping in, just in case that changes)
#echo -e "\nCommand Run: mkdir -p ${computername}/LiveResponseData/CopiedFiles/Logs/private/var" | tee -a "${computername}/${computername}""_Processing_Details.txt"
#mkdir -p ${computername}/LiveResponseData/CopiedFiles/Logs/private/var
echo -e "\nCommand Run: mkdir -p ${computername}/LiveResponseData/CopiedFiles/Logs/Library/Logs" | tee -a "${computername}/${computername}""_Processing_Details.txt"
mkdir -p ${computername}/LiveResponseData/CopiedFiles/Logs/Library/Logs


#Copying logs
echo -e "\nCommand Run: cp /var/log/*.log* ${computername}/LiveResponseData/CopiedFiles/Logs/var" | tee -a "${computername}/${computername}""_Processing_Details.txt"
cp /var/log/*.log* ${computername}/LiveResponseData/CopiedFiles/Logs/var
echo -e "\nCommand Run: cp /var/log/*.out ${computername}/LiveResponseData/CopiedFiles/Logs/var" | tee -a "${computername}/${computername}""_Processing_Details.txt"
cp /var/log/*.out ${computername}/LiveResponseData/CopiedFiles/Logs/var
echo -e "\nCommand Run: cp -r /Library/Logs/* ${computername}/LiveResponseData/CopiedFiles/Logs/Library/Logs" | tee -a "${computername}/${computername}""_Processing_Details.txt"
cp -r /Library/Logs/* ${computername}/LiveResponseData/CopiedFiles/Logs/Library/Logs
#Unified Log collection
#Checking for administrator privileges. We need this to actually collect the Unified Logs
if [[ $EUID -ne 0 ]]; then
	echo -e "You do not have root permissions. Skipping Unified Log copying"
	printf "You do not have root permissions. Skipping Unified Log copying\n" >> "${computername}/${computername}""_Processing_Details.txt"
else
	#Creating the directory for the Unified Logs 
	echo -e "\nCommand Run: mkdir -p ${computername}/LiveResponseData/CopiedFiles/Logs/UnifiedLogs" | tee -a "${computername}/${computername}""_Processing_Details.txt"
    mkdir -p ${computername}/LiveResponseData/CopiedFiles/Logs/UnifiedLogs
    #Actually collection the Unified Logs, since the permissions check passed
    echo -e "\nCommand Run: sudo log collect --output ${computername}/LiveResponseData/CopiedFiles/Logs/UnifiedLogs/${computername}.logarchive" | tee -a "${computername}/${computername}""_Processing_Details.txt"
    sudo log collect --output ${computername}/LiveResponseData/CopiedFiles/Logs/UnifiedLogs/${computername}.logarchive
fi


echo ""
echo -e "** Completed running ${modulename} module **\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
echo ""
return