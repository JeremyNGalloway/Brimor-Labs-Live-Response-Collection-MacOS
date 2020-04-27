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
#System Profiler
echo -e "\nCommand Run: system_profiler" | tee -a "${computername}/${computername}""_Processing_Details.txt"
#system_profiler 1>> ${computername}/LiveResponseData/BasicInfo/system_profiler.txt
#sw_vers
echo -e "\nCommand Run: sw_vers" | tee -a "${computername}/${computername}""_Processing_Details.txt"
sw_vers 1>> ${computername}/LiveResponseData/BasicInfo/sw_vers.txt
#pwd
echo -e "\nCommand Run: pwd" | tee -a "${computername}/${computername}""_Processing_Details.txt"
pwd 1>> ${computername}/LiveResponseData/BasicInfo/DirectoryLRClaunchedfrom.txt
#csrutil status
echo -e "\nCommand Run: csrutil status" | tee -a "${computername}/${computername}""_Processing_Details.txt"
csrutil status>> ${computername}/LiveResponseData/BasicInfo/SIP-status.txt
#df -Hl
echo -e "\nCommand Run: df -Hl" | tee -a "${computername}/${computername}""_Processing_Details.txt"
df -Hl 1>> ${computername}/LiveResponseData/BasicInfo/AllMountedDisks.txt
#date
echo -e "\nCommand Run: date" | tee -a "${computername}/${computername}""_Processing_Details.txt"
date 1>> ${computername}/LiveResponseData/BasicInfo/date.txt
#hostname
echo -e "\nCommand Run: hostname" | tee -a "${computername}/${computername}""_Processing_Details.txt"
hostname 1>> ${computername}/LiveResponseData/BasicInfo/hostname.txt
#who
echo -e "\nCommand Run: who" | tee -a "${computername}/${computername}""_Processing_Details.txt"
who 1>> ${computername}/LiveResponseData/BasicInfo/Logged_In_Users.txt
#ps auxwww
echo -e "\nCommand Run: ps auxwww" | tee -a "${computername}/${computername}""_Processing_Details.txt"
ps auxwww 1>> ${computername}/LiveResponseData/BasicInfo/List_of_Running_Processes.txt
#mount
echo -e "\nCommand Run: mount" | tee -a "${computername}/${computername}""_Processing_Details.txt"
mount 1>> ${computername}/LiveResponseData/BasicInfo/Mounted_items.txt
#Full file listing
echo -e "\nCommand Run: ls -alR /" | tee -a "${computername}/${computername}""_Processing_Details.txt"
echo -ne '\n' | ls -alR / 1>> ${computername}/LiveResponseData/BasicInfo/Full_file_listing.txt
#diskutil
echo -e "\nCommand Run: diskutil" | tee -a "${computername}/${computername}""_Processing_Details.txt"
diskutil list 1>> ${computername}/LiveResponseData/BasicInfo/Disk_utility.txt
#kexstat
echo -e "\nCommand Run: kextstat -l" | tee -a "${computername}/${computername}""_Processing_Details.txt"
kextstat -l 1>> ${computername}/LiveResponseData/BasicInfo/Loaded_Kernel_Extensions.txt
#sw_vers Product version, for handling brctl (and anything else it might need
swvers=$(sw_vers -productVersion)

# System context knowledge database "knowledgeC.db" found under /private/var/db/CoreDuet/Knowledge   
if [[ $EUID -eq 0 && -f "/private/var/db/CoreDuet/Knowledge/knowledgeC.db" ]]; then
    #Copy system knowledgeC database file(s)	
	echo -e "\nCommand Run: cp -rf /private/var/db/CoreDuet/Knowledge ${computername}/LiveResponseData/CopiedFiles" | tee -a "${computername}/${computername}""_Processing_Details.txt"	
	cp -rf "/private/var/db/CoreDuet/Knowledge" ${computername}/LiveResponseData/CopiedFiles
else
	echo "** Either file /private/var/db/CoreDuet/Knowledge/knowledgeC.db does not exist\nor you do not have the needed permissions to copy the file ***\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
fi

# brctl pull. Because bird is the word. This section specifically handles 10.13
if [[ $EUID -eq 0 && ${swvers} =~ '10.13' ]]; then
    #Pulls data from brctl	
	echo -e "\nCommand Run: sudo brctl diagnose -e ${computername}/brctl\n***Saving output under ${computername}/LiveResponseData/BasicInfo/brctl.tgz" | tee -a "${computername}/${computername}""_Processing_Details.txt"		
	echo -ne '\n' | sudo brctl diagnose -e ${computername}/brctl
	wait
	echo -e "\nCommand Run: cp -f \"/var/tmp/${computername}/brctl.tgz\" ${computername}/LiveResponseData/BasicInfo/brctl.tgz" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	cp -f "/var/tmp/${computername}/brctl.tgz" ${computername}/LiveResponseData/BasicInfo/brctl.tgz
	echo -e "\nCommand Run: sudo rm -rf \"/var/tmp/${computername}\"" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	sudo rm -rf "/var/tmp/${computername}"
	echo -e "\nCommand Run: osascript -e 'tell application \"Finder\" to close window \"tmp\"'" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	osascript -e 'tell application "Finder" to close window "tmp"'
#brctl pull. Because bird is the word. This section specifically handles 10.14
elif [[ $EUID -eq 0 && ${swvers} =~ '10.14' ]]; then
    #Pulls data from brctl	
	echo -e "\nCommand Run: sudo brctl diagnose -e ${computername}/brctl\n***Saving output under ${computername}/LiveResponseData/BasicInfo/brctl.tgz" | tee -a "${computername}/${computername}""_Processing_Details.txt"		
	echo -ne '\n' | sudo brctl diagnose -e ${computername}/brctl
	wait
	echo -e "\nCommand Run: cp -f \"/var/tmp/${computername}/brctl.tgz\" ${computername}/LiveResponseData/BasicInfo/brctl.tgz" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	cp -f "/var/tmp/${computername}/brctl.tgz" ${computername}/LiveResponseData/BasicInfo/brctl.tgz
	echo -e "\nCommand Run: sudo rm -rf \"/var/tmp/${computername}\"" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	sudo rm -rf "/var/tmp/${computername}"
# brctl pull. Because bird is the word. This section specifically handles 10.12 and lower  
elif [[ $EUID -eq 0 ]]; then
    #Pulls data from brctl	
	echo -e "\nCommand Run: sudo brctl diagnose ${computername}/brctl\n***Saving output under ${computername}/LiveResponseData/BasicInfo/brctl.tgz" | tee -a "${computername}/${computername}""_Processing_Details.txt"	
	echo -ne '\n' | sudo brctl diagnose ${computername}/brctl
	wait
	echo -e "\nCommand Run: cp -f \"/var/tmp/${computername}/brctl.tgz\" ${computername}/LiveResponseData/BasicInfo/brctl.tgz" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	cp -f "/var/tmp/${computername}/brctl.tgz" ${computername}/LiveResponseData/BasicInfo/brctl.tgz
	echo -e "\nCommand Run: sudo rm -rf \"/var/tmp/${computername}\"" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	sudo rm -rf "/var/tmp/${computername}"
	echo -e "\nCommand Run: osascript -e 'tell application \"Finder\" to close window \"tmp\"'" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	osascript -e 'tell application "Finder" to close window "tmp"'
else
	echo -e "\n** Skipping brctl, not running as root ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
fi



# Core Analytics files found under /private/var/db/analyticsd/ 
if [[ $EUID -eq 0 && -d "/private/var/db/analyticsd/" ]]; then
    #Copy Core Analytics files & folders	
	echo -e "\nCommand Run: cp -rf /private/var/db/analyticsd/ ${computername}/LiveResponseData/CopiedFiles/analyticsd" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	cp -rf "/private/var/db/analyticsd/" ${computername}/LiveResponseData/CopiedFiles/analyticsd
else
	echo -e "\n** Either directory /private/var/db/analyticsd/ does not exist\nor you do not have the needed permissions to copy the file ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
fi


# Spotlight files found under ./Spotlight-V100
if [[ $EUID -eq 0 && ${swvers} =~ '10.14' && -d "/.Spotlight-V100/" ]]; then
    #Copy Spotlight files & folders
    #Keeping this in, but commented out, fo now, because there might be a way to do this natively, without coloring in a "gray" area with regards to security
	#echo -e "\nCommand Run: cp -rf /.Spotlight-V100/ ${computername}/LiveResponseData/CopiedFiles/Spotlight" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	#cp -rf "/.Spotlight-V100/" ${computername}/LiveResponseData/CopiedFiles/Spotlight
	echo -e "\n** Either directory /.Spotlight-V100/ does not exist\nor you do not have the needed permissions to copy the file ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"	
elif [[ $EUID -eq 0 && -d "/.Spotlight-V100/" ]]; then
    #Copy Spotlight files & folders	
	echo -e "\nCommand Run: cp -rf /.Spotlight-V100/ ${computername}/LiveResponseData/CopiedFiles/Spotlight" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	cp -rf "/.Spotlight-V100/" ${computername}/LiveResponseData/CopiedFiles/Spotlight
else
	echo -e "\n** Either directory /.Spotlight-V100/ does not exist\nor you do not have the needed permissions to copy the file ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
fi

echo ""
echo -e "** Completed running ${modulename} module **\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
echo ""
return