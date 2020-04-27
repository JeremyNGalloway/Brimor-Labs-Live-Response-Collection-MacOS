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


#INITIAL HOUSEKEEPING
set -o pipefail
ScriptStart=$(date +%s)
lrcbuildname="Live Response Collection (Cedarpelta Build - 20190905)"
scriptname=$(basename "$0")
#Getting directory from where the script is running
get_script_dir () {
    SOURCE="${BASH_SOURCE[0]}"
    # Whole $SOURCE is a symlink, resolve it
    while [ -h "${SOURCE}" ]; do
        DIR="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"
        SOURCE="$( readlink "$SOURCE" )"
        [[ ${SOURCE} != /* ]] && SOURCE="${DIR}/${SOURCE}"
        done
    DIR="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"
    echo "${DIR}"
}    
directorywherescriptrunsfrom=$(get_script_dir)        
modulepath="${directorywherescriptrunsfrom}/Modules/"
runningfromexternal="no"
swversion=$(sw_vers -productVersion)
cname=$(hostname -s)
ts=$(date +%Y%m%d_%H%M%S)
computername=${cname}\_${ts}
mkdir -p "${computername}"
FILE_STDERR="${computername}/${computername}_Processing_Details.txt"
exec 2> >(tee -a "${FILE_STDERR}" >&2)
echo -e "\n***** All commands run and (if applicable) any error messages *****\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
echo -e "\nOS Type: Mac" | tee -a "${computername}/${computername}""_Processing_Details.txt"
echo -e "\nComputername: ${cname}" | tee -a "${computername}/${computername}""_Processing_Details.txt"
echo -e "\nTime stamp: ${ts}" | tee -a "${computername}/${computername}""_Processing_Details.txt"
echo -e "\nLive Response Collection version: ${lrcbuildname}" | tee -a "${computername}/${computername}""_Processing_Details.txt"
echo -e "\nLive Response Collection script run: ${scriptname}" | tee -a "${computername}/${computername}""_Processing_Details.txt"
echo -e "\nmkdir -p ${computername}" | tee -a "${computername}/${computername}""_Processing_Details.txt"

#DIRECTORY CREATION MODULE
#Running directory creation module
echo ""
echo "***** Beginning Mac Directory Creation module *****"
source "${directorywherescriptrunsfrom}/Modules/Mac-DirectoryCreation.sh"
echo "***** Ending Mac Directory Creation module *****"
echo ""

#Checking for administrator privileges. We need this for the memory dump and disk imaging and FSEvents copying
if [[ $EUID -ne 0 ]]; then
	echo -e "You do not have root permissions. Skipping FSEvents copying"
	printf "You do not have root permissions. Skipping FSEvents copying\n" >> "${computername}/${computername}""_Processing_Details.txt"
else
	#Running FSEventsd copying module
	echo ""
	echo "***** Beginning Mac FSEventsd module *****"
	source "${directorywherescriptrunsfrom}/Modules/Mac-fseventsdCopying.sh"
	echo "***** Ending Mac FSEventsd module *****"
	echo ""
fi


#HIDDEN FILES - May eventually put something in here

#LOG COPYING
#Running log copying module
echo ""
echo "***** Beginning Mac log copying module *****"
source "${directorywherescriptrunsfrom}/Modules/Mac-LogCopying.sh"
echo "***** Ending Mac log copying module *****"
echo ""

#BASIC INFORMATION
#Running basic information module
echo ""
echo "***** Beginning Mac basic information module *****"
source "${directorywherescriptrunsfrom}/Modules/Mac-BasicInfo.sh"
echo "***** Ending Mac basic information module *****"
echo ""


#USER INFORMATION
#Running user information module
echo ""
echo "***** Beginning Mac user information module *****"
source "${directorywherescriptrunsfrom}/Modules/Mac-UserInfo.sh"
echo "***** Ending Mac user information module *****"
echo ""


#PERSISTENCE MECHANISMS
#Running persistence mechanisms module
echo ""
echo "***** Beginning Mac persistence mechanism module *****"
source "${directorywherescriptrunsfrom}/Modules/Mac-PersistenceMechanisms.sh"
echo "***** Ending Mac persistence mechanism module *****"
echo ""


#NETWORK INFO
#Running persistence mechanisms module
echo ""
echo "***** Beginning Mac network information module *****"
source "${directorywherescriptrunsfrom}/Modules/Mac-NetworkInfo.sh"
echo "***** Ending Mac network information module *****"
echo ""


#PROCESSING DETAILS AND HASHES
#Running hashing module
echo ""
echo "***** Beginning Mac LRC hashing module *****"
source "${directorywherescriptrunsfrom}/Modules/Mac-LRCHashing.sh"
echo "***** Ending Mac LRC hashing module *****"
echo ""


#CHMOD CLEANUP
#Checking for administrator privileges. We need to chmod directories, just in case
if [[ $EUID -ne 0 ]]; then
	echo -e "\nYou do not have root permissions. Skipping chmod cleanup" | tee -a "${computername}/${computername}""_Processing_Details.txt"
else
#Running chmod just to clean up
	echo ""
	echo -e "\n***** Beginning chmod cleanup *****" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	echo -e "\n** sudo chmod -R 0755 ${computername}/ ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
    sudo chmod -R 0755 ${computername}/
	echo -e "\n***** Ending chmod cleanup *****" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	echo ""
fi

#Finishing up
echo Congratulations\! The BriMor Labs Mac Live Response Collection is now complete.
ScriptEnd=$(date +%s)
ScriptRunTime=$(expr ${ScriptEnd} - ${ScriptStart})
if (("${ScriptRunTime}" < 60)); then
	echo -e "\nThe script took a total of ${ScriptRunTime} seconds to run\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	echo -e "\n...Exiting script now.\nEnd Of Line.\n\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
else
	Minutes=$(expr ${ScriptRunTime} / 60)
	Seconds=$(expr ${ScriptRunTime} % 60)
	echo -e "\nThe script took a total of ${Minutes} minutes and ${Seconds} seconds to run\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	echo -e "\n...Exiting script now.\nEnd Of Line.\n\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
fi
	
exit

#LIST_OF_ALL_UPDATES
# Live Response Collection (Cedarpelta Build - 20180907) - Fixed overall bash "properness". Added a bunch of modules & functionality. Added SIP detection.
# Live Response Collection (Bambiraptor Build - 20161212) - Added automated disk imaging using dd. Added Complete, Memory Dump, and Triage options. Fixed small typos
# Live Response Collection (Allosaurus Build - 20160112) - Added memory dump extraction, added modules (similar to Windows Live Response Collection). Added logging file. Many changes to resemble the Windows Live Response Collection. Added change to volume mapping and free size computation to work with external drives attached with the same name and account for spaces in drive name (Thanks @CdtDelta)!
#Version 1.4 Due to a coding oversight, I forgot to put "LiveResponseData" in the file path. Thanks very much to Cristina Roura for pointing that out!
#Version 1.3 Added automated MD5 and SHA256 file hashing of all output files, saved as "Processing_Details_and_Hashes.txt"