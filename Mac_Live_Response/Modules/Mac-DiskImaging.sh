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

#Checking to see if SIP is running. If it is, we will not attempt to collect memory
issipon=$(csrutil status)
if [[ "${issipon}" =~ "status: enabled" ]]; then
    echo ""
    echo -e "\n!!!!! WARNING! SIP is enabled. Skipping automated memory dump !!!!!" | tee -a "${computername}/${computername}""_Processing_Details.txt"
    echo ""
    echo -e "\n ***** Completed running ${modulename} module *****" | tee -a "${computername}/${computername}""_Processing_Details.txt"
    echo ""
    return
fi

#Running disk imaging portion if SIP test passes
if [[ "${directorywherescriptrunsfrom}" =~ "Volumes" ]]; then
	runningfromexternal="yes" #Congratulations! It is running externally!
	shortpath=$(egrep -oh "/Volumes/.*?/" <<< ${directorywherescriptrunsfrom}) #Getting just the partial path. This is used for free space and suches
	trimsp=$(echo $shortpath | sed 's:/*$::') #Trimming trailing slash
	echo -e "\nCommand Run: df \"${trimsp}\"" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	df "${trimsp}" | sed 's/\(.*\)/\1/' 1>> ${computername}/LiveResponseData/BasicInfo/ScriptLocationData.txt
	echo -e "\nCommand Run: mappeddrive=$(df -Pl | awk '{printf "%s %s %s %s\n",$1,$2,$4,$6}')" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	mappeddrive=$(df "$trimsp" | sed 's/\(.*\)/\1/')
	IFS=$'\n'
 	#Capturing Disk Image of target system 
 	echo -e "\ndf -Pl" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	df -Pl >> ${computername}/LiveResponseData/BasicInfo/MappedDrives.txt
	for line in $(<${computername}/LiveResponseData/BasicInfo/MappedDrives.txt)
	do	
		if [[ ! "${line}" =~ "Avail" ]] && [[ ! "${line}" =~ "${trimsp}" ]]; then
			drivemountpoint=$(echo $line | awk '{printf "%s",$1}') #Getting the mount point
			totaldrivesize=$(echo $line | awk '{printf "%s",$2}') #Getting free space
			echo -e "\ndmp is ${drivemountpoint}\ntds is ${totaldrivesize}\ntrimsp is ${trimsp}\n"
			realtds=$(( $totaldrivesize * 512))
			# This will update the destination drive space each time, to ensure we have the free space needed to do it
			updatedextdrivefreespace=$(df -Pl ${trimsp}| sed -e /Available/d | awk '{printf "%s",$4}' )
			realupdatedextdrivefreespace=$(( ${updatedextdrivefreespace} * 512))
			drivename=$(echo ${drivemountpoint} | sed 's:/dev/::')
			#Since the disk drive is busy and in use during live acquisition, we must use corresponding "raw" disk to capture the image
			raw="/dev/r"
			rawname=(${raw}${drivename})
			echo -e "Raw Disk is $rawname" >> ${computername}/LiveResponseData/BasicInfo/MappedDrives.txt
			diskutil enableOwnership ${rawname}
			echo ""
			echo -e "\nDrive to image mount point is ${drivemountpoint}" | tee -a "${computername}/${computername}""_Processing_Details.txt"
			echo -e "\nDrive to image size is ${realtds}\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
			#Check to make sure there is enough free space for the disk image
			if [ "${realtds}" -lt "${realupdatedextdrivefreespace}" ]; then
				echo "Target drive is $realtds bytes in size"
				echo "Destination has $realupdatedextdrivefreespace bytes free"
				echo "We passed the size imaging checks! Disk imaging will begin"
				echo
				echo "Please be patient, this may take some time"
				echo
				# sudo dd if=$rawname | ${directorywherescriptrunsfrom}/Tools/ftkimager/ftkimager - "${computername}/ForensicImages/DiskImage/${computername}""_$drivename" --e01 --frag 4096M --compress 4 --verify
				#Original imaging command: #sudo dd if=${rawname} bs=4k conv=sync,noerror | tee "${computername}/ForensicImages/DiskImage/${computername}""_$drivename.dd" | md5 > "${computername}/ForensicImages/DiskImage/${computername}""_$drivename-md5_hash.txt"
				sudo dd if=${rawname} conv=notrunc,noerror,sync bs=4k | gzip -1c | tee "${computername}/ForensicImages/DiskImage/${computername}""_$drivename.dd.gz" | md5 > "${computername}/ForensicImages/DiskImage/${computername}""_$drivename-md5_hash.txt" & sleep 3 & while pkill -SIGINFO dd; do sleep 1; clear; date; done
				echo
				echo -e "\nDisk imaging is complete. Please check the Image Summary text file for verification." | tee -a "${computername}/${computername}""_Processing_Details.txt"
			else 
				echo -e "\nTarget drive is ${realtds} bytes in size and the extenal drive has ${realupdatedextdrivefreespace} of available free space. This is not enough free space to a forensic disk image." | tee -a "${computername}/${computername}""_Processing_Details.txt"
				echo -e "\nNot enough free space on external drive to create a forensic disk image." | tee -a "${computername}/${computername}""_Processing_Details.txt"
			fi
		fi
	done

elif [[ ! "${directorywherescriptrunsfrom}" =~ "Volumes" ]]; then
	echo -e "\nThis script is running from the target host. We caution you to not run this script for the host.\n!!!!! Please run from an externally connected drive to collect memory and/or disk image !!!!!" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	return
fi  




echo ""
echo -e "** Completed running ${modulename} module **\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
echo ""
return