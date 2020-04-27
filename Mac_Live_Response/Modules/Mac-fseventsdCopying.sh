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
#Looking for fseventsd
if [ -e /.fseventsd ];
then
	#Creating the proper directory
	echo -e "\nComamnd Run: mkdir -p $computername/LiveResponseData/CopiedFiles/fsevents" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	mkdir -p $computername/LiveResponseData/CopiedFiles/fsevents
	#Copying the FSEvents files
	echo -e "\nCommand Run: cp -r /.fseventsd $computername/LiveResponseData/CopiedFiles/fsevents" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	cp -r /.fseventsd $computername/LiveResponseData/CopiedFiles/fsevents
else
   echo -e "\nThe FSEvents files under the directory /.fseventsd were not found on this system." | tee -a "${computername}/${computername}""_Processing_Details.txt"
fi

echo ""
echo -e "** Completed running ${modulename} module **\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
echo ""
return