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
if [[ "{$issipon}" =~ "status: enabled" ]]; then
    echo ""
    echo -e "\n!!!!! WARNING! SIP is enabled. Skipping automated memory dump !!!!!" | tee -a "${computername}/${computername}""_Processing_Details.txt"
    echo ""
    echo -e "\n***** Completed running ${modulename} module *****" | tee -a "${computername}/${computername}""_Processing_Details.txt"
    echo ""
    return
fi


#Determine size of memory
echo -e "\nCommand Run: memorysize=$(sysctl -a | grep memsize | awk '{printf "%s",$2}')" | tee -a "${computername}/${computername}""_Processing_Details.txt"
memorysize=$(sysctl -a | grep memsize | awk '{printf "%s",$2}') >> "${computername}/${computername}""_Processing_Details.txt" 2>&1
memorysize=${memorysize//[!0-9]/}	
echo -e "\nCommand Run: sysctl -a | grep memsize >> ${computername}/LiveResponseData/BasicInfo/TotalSizeOfMemory.txt" | tee -a "${computername}/${computername}""_Processing_Details.txt"
sysctl -a | grep memsize 1>> ${computername}/LiveResponseData/BasicInfo/TotalSizeOfMemory.txt
echo -e "Total size of installed memory is $memorysize" | tee -a "${computername}/${computername}""_Processing_Details.txt"

#This will be required if we do disk imaging in the future. For now, it is not a requirement
if [[ "${directorywherescriptrunsfrom}" =~ "Volumes" ]]; then
	runningfromexternal="yes" #Congratulations! It is running externally!
	shortpath=$(egrep -oh "/Volumes/.*?/" <<< ${directorywherescriptrunsfrom}) #Getting just the partial path. This is used for free space and suches
	trimsp=$(echo $shortpath | sed 's:/*$::') #Trimming trailing slash
	echo -e "\nCommand Run: df \"${trimsp}\"\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	df "$trimsp" | sed 's/\(.*\)/\1/' 1>> ${computername}/LiveResponseData/BasicInfo/ScriptLocationData.txt
	echo -e "\nCommand Run: mappeddrive=$(df -Pl | awk '{printf "%s %s %s %s\n",$1,$2,$4,$6}')" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	mappeddrive=$(df "$trimsp" | sed 's/\(.*\)/\1/')
	IFS=$'\n'
	for line in $(<${computername}/LiveResponseData/BasicInfo/ScriptLocationData.txt)
	do
		if [[ "${line}" =~ "${trimsp}" ]]; then
			filesystemmountpoint=$(echo $line | awk '{printf "%s",$1}') #Getting the mount point
			externaldrivefreespace=$(echo $line | awk '{printf "%s",$4}') #Getting free space
			externaldrivefreespace=${externaldrivefreespace//[!0-9]/}
			realedfs=$(( $externaldrivefreespace * 512))
			realedfs=${realedfs//[!0-9]/}
			echo -e "\nExt drive mount point ${filesystemmountpoint}\nExt drive free space ${realedfs}" | tee -a "${computername}/${computername}""_Processing_Details.txt"
			#Ensuring memorysize is less than free space on disk
			if [ "${memorysize}" -lt "${realedfs}" ]; then
				
				#Changing ownership of external disk for current user so we can automate memory dump
				echo -e "\nCommand Run: diskutil enableOwnership $filesystemmountpoint" | tee -a "${computername}/${computername}""_Processing_Details.txt"
				diskutil enableOwnership ${filesystemmountpoint}
				
				#Other memory dump stuff
				echo -e "\nCommand Run: unzip ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/osxpmem_2.1.zip -d ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp" | tee -a "${computername}/${computername}""_Processing_Details.txt"
				unzip ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/osxpmem_2.1.zip -d ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp

				echo -e "\mCommand Run: chown -R 0:0 ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp/osxpmem.app/MacPmem.kext" | tee -a "${computername}/${computername}""_Processing_Details.txt"
				chown -R 0:0 ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp/osxpmem.app/MacPmem.kext

				echo -e "\nCommand Run: kextload ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp/osxpmem.app/MacPmem.kext\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"				
				kextload ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp/osxpmem.app/MacPmem.kext
								
				echo -e "\nCommand Run: ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp/osxpmem.app/osxpmem -p -m -t -c snappy -o ""${computername}/ForensicImages/Memory/${computername}""_memory.aff4\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
				${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp/osxpmem.app/osxpmem -p -m -t -c snappy -o ""${computername}/ForensicImages/Memory/${computername}""_memory.aff4""
				md5 "${computername}/ForensicImages/Memory/${computername}""_memory.aff4" >> "${computername}/ForensicImages/Memory/${computername}""_memory_dmp_hashes.txt"
				shasum -a 256 "${computername}/ForensicImages/Memory/${computername}""_memory.aff4" >> "${computername}/ForensicImages/Memory/${computername}""_memory_dmp_hashes.txt"

				echo -e "\nCommand Run: kextunload ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp/osxpmem.app/MacPmem.kext" | tee -a "${computername}/${computername}""_Processing_Details.txt"			
				kextunload ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp/osxpmem.app/MacPmem.kext

				echo -e "\nCommand Run: rm -rf \"${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp\"*" | tee -a "${computername}/${computername}""_Processing_Details.txt"
				rm -rf "${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp"*

			fi
		fi
	done
	
elif [[ ! "${directorywherescriptrunsfrom}" =~ "Volumes" ]]; then
	echo -e "\ndf -Pl" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	df -Pl >> ${computername}/LiveResponseData/BasicInfo/MappedDrives.txt

	IFS=$'\n'
	realedfs=$(diskutil info / | grep "Free Space" | awk '{printf "%s\n",$6}' | sed 's:(::')
	realedfs=${realedfs//[!0-9]/}	
	echo -e "\nTotal size of disk free space is $realedfs\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	#Checking to see if SIP is running. If it is, we cannot image memory live
	issipon=$(csrutil status)
	if [[ ${issipon} =~ "enabled." ]]; then
	    echo -e "\n*****WARNING*****\nSystem Integrity Protection is enabled.\nBecause of this, acquiring memory is not possible.\nReturning to data collection" | tee -a "${computername}/${computername}""_Processing_Details.txt"
        echo ""
        echo -e "\n***** Completed running ${modulename} module *****" | tee -a "${computername}/${computername}""_Processing_Details.txt"
        echo ""
    fi     
	#Ensuring memorysize is less than free space on disk
	if [ "${memorysize}" -lt "${realedfs}" ]; then
		#Other memory dump stuff
		echo -e "\nunzip ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/osxpmem_2.1.zip -d ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp\n" >> "${computername}/${computername}""_Processing_Details.txt"
		unzip ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/osxpmem_2.1.zip -d ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp

		echo -e "\nchown -R 0:0 ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp/osxpmem.app/MacPmem.kext" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		chown -R root:wheel ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp/osxpmem.app/
		chown -R 0:0 ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp/osxpmem.app/
	
		echo -e "\nkextload ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp/osxpmem.app/MacPmem.kext" | tee -a "${computername}/${computername}""_Processing_Details.txt"	
		sudo kextload ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp/osxpmem.app/MacPmem.kext

		echo -e "${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp/osxpmem.app/osxpmem --elf -o ""${computername}/ForensicImages/Memory/${computername}""_memory.dmp" | tee -a "${computername}/${computername}""_Processing_Details.txt"	
		${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp/osxpmem.app/osxpmem --elf -o "${computername}/ForensicImages/Memory/${computername}""_memory.dmp"
		md5 "${computername}/ForensicImages/Memory/${computername}""_memory.dmp" >> "${computername}/ForensicImages/Memory/${computername}""_memory_dmp_hashes.txt"
		shasum -a 256 "${computername}/ForensicImages/Memory/${computername}""_memory.dmp" >> "${computername}/ForensicImages/Memory/${computername}""_memory_dmp_hashes.txt"		

		echo -e "\nkextunload ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp/osxpmem.app/MacPmem.kext" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		kextunload ${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp/osxpmem.app/MacPmem.kext

		echo -e "\nrm -rf \"${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp\"*" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		rm -rf "${directorywherescriptrunsfrom}/Tools/osxpmem_2.1/temp"*

	fi

else
	echo -e "\nAutomated memory dump cannot be completed due to an unknown reason\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"

fi

echo ""
echo -e "\n** Completed running ${modulename} module **\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
echo ""
return