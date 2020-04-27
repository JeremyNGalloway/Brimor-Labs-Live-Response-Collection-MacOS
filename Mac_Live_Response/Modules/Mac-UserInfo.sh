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

echo -e "\nCommand Run: cat /etc/passwd" | tee -a "${computername}/${computername}""_Processing_Details.txt"
cat /etc/passwd 1>> ${computername}/LiveResponseData/UserInfo/passwd.txt

echo -e "\nCommand Run: cat /etc/group" | tee -a "${computername}/${computername}""_Processing_Details.txt"
cat /etc/group 1>> ${computername}/LiveResponseData/UserInfo/group.txt

for i in `ls /Users/`
do

	# bash history
	if [ -e /Users/${i}/.bash_history ]; then
		echo -e "\nCommand Run: cat /Users/${i}/.bash_history" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cat /Users/${i}/.bash_history 1>> ${computername}/LiveResponseData/UserInfo/User-${i}-bash_History.txt
	else
		echo -e "** File /Users/${i}/.bash_history does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi

	# sh history
	if [ -e /Users/${i}/.sh_history ]; then
		echo -e "\nCommand Run: cat /Users/${i}/.sh_history" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cat /Users/${i}/.sh_history 1>> ${computername}/LiveResponseData/UserInfo/User-${i}-sh_History.txt
	else
		echo -e "** File /Users/${i}/.sh_history does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi

	# .lesshst
	if [ -e /Users/${i}/.lesshst ]; then
		echo -e "\nCommand Run: cat /Users/${i}/.lesshst" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cat /Users/${i}/.lesshst 1>> ${computername}/LiveResponseData/UserInfo/User-${i}-lesshst.txt
	else
		echo -e "** File /Users/${i}/.lesshst does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi

	# .vimrc
	if [ -e /Users/${i}/.vimrc ]; then
		echo -e "\nCommand Run: cat /Users/${i}/.vimrc" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cat /Users/${i}/.vimrc 1>> ${computername}/LiveResponseData/UserInfo/User-${i}-vimrc.txt
	else
		echo -e "** File /Users/${i}/.vimrc does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi

	# .wget-hsts
	if [ -e /Users/${i}/.wget-hsts ]; then
		echo -e "\nCommand Run: cat /Users/${i}/.wget-hsts" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cat /Users/${i}/.wget-hsts 1>> ${computername}/LiveResponseData/UserInfo/User-${i}-wget-hsts.txt
	else
		echo -e "** File /Users/${i}/.wget-hsts does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi

	# Launch Agents
	if [ -d /Users/${i}/Library/LaunchAgents/ ]; then
		echo -e "\nCommand Run: ls -al /Users/${i}/Library/LaunchAgents/ | grep -v ^d" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		ls -al /Users/${i}/Library/LaunchAgents/ | grep -v ^d 1>> ${computername}/LiveResponseData/PersistenceMechanisms/User-${i}-LaunchAgents.txt
	else
		echo -e "** Directory /Users/${i}/Library/LaunchAgents/ does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi

	# Login Window
	if [ -f /Users/${i}/Library/Preferences/loginwindow.plist ]; then
		echo -e "\nCommand Run: plutil -convert json /Users/${i}/Library/Preferences/loginwindow.plist -o ${computername}/LiveResponseData/PersistenceMechanisms/User-${i}-loginwindow_plist.txt" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		plutil -convert json /Users/${i}/Library/Preferences/loginwindow.plist -o ${computername}/LiveResponseData/PersistenceMechanisms/User-${i}-loginwindow_plist.txt
	else
		echo -e "** File /Users/${i}/Library/Preferences/loginwindow.plist does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi

	# AddressBook Me
	if [ -f /Users/${i}/Library/Preferences/AddressBookMe.plist ]; then
		echo -e "\nCommand Run: plutil -convert json /Users/${i}/Library/Preferences/AddressBookMe.plist -o ${computername}/LiveResponseData/UserInfo/User-${i}-AddressBookMe_plist.txt" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		plutil -convert json /Users/${i}/Library/Preferences/AddressBookMe.plist -o ${computername}/LiveResponseData/UserInfo/User-${i}-AddressBookMe.plist_txt
		echo -e "\n\n" >> "${computername}/${computername}""_Processing_Details.txt"
	else
		echo -e "** File /Users/${i}/Library/Preferences/AddressBookMe.plist does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi

	# AddressBook (newer versions of OSX)
	if [ -f /Users/${i}/Library/Preferences/com.apple.AddressBook.plist ]; then
		echo -e "\nCommand Run: plutil -convert xml1 /Users/${i}/Library/Preferences/com.apple.AddressBook.plist -o ${computername}/LiveResponseData/UserInfo/User-${i}-AddressBook_plist.txt" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		plutil -convert xml1 /Users/${i}/Library/Preferences/com.apple.AddressBook.plist -o ${computername}/LiveResponseData/UserInfo/User-${i}-AddressBook_plist.txt
	else
		echo -e "** File /Users/${i}/Library/Preferences/AddressBook.plist does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi

	# Login Items
	if [ -f /Users/${i}/Library/Preferences/com.apple.loginitems.plist ]; then
		echo -e "\nCommand Run: plutil -convert json /Users/${i}/Library/Preferences/com.apple.loginitems.plist -o ${computername}/LiveResponseData/PersistenceMechanisms/User-${i}-LaunchedLogInItems_plist.txt" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		plutil -convert json /Users/${i}/Library/Preferences/com.apple.loginitems.plist -o ${computername}/LiveResponseData/PersistenceMechanisms/User-${i}-LaunchedLogInItems_plist.txt
	else
		echo -e "** File /Users/${i}/Library/Preferences/com.apple.loginitems.plist does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi

	# Recent Items
	if [ -f /Users/${i}/Library/Preferences/com.apple.recentitems.plist ]; then
		echo -e "\nCommand Run: plutil -convert xml1 /Users/${i}/Library/Preferences/com.apple.recentitems.plist -o ${computername}/LiveResponseData/UserInfo/User-${i}-RecentItems_plist.txt\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		plutil -convert xml1 /Users/${i}/Library/Preferences/com.apple.recentitems.plist -o ${computername}/LiveResponseData/UserInfo/User-${i}-RecentItems_plist.txt
	else
		echo -e "** File /Users/${i}/Library/Preferences/com.apple.recentitems.plist does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi

	# Apple Finder found under /Users/<username>/Library/Preferences/com.apple.finder.plist
	if [ -f /Users/${i}/Library/Preferences/com.apple.finder.plist ]; then
		echo -e "Command Run: plutil -convert xml1 /Users/${i}/Library/Preferences/com.apple.finder.plist -o ${computername}/LiveResponseData/UserInfo/User-${i}-AppleFinderItems_plist.txt" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		plutil -convert xml1 /Users/${i}/Library/Preferences/com.apple.finder.plist -o ${computername}/LiveResponseData/UserInfo/User-${i}-AppleFinderItems_plist.txt
	else
		echo -e "** File /Users/${i}/Library/Preferences/com.apple.finder.plist does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi

#FILE COPYING SECTION

	# User context knowledge database "knowledgeC.db" found under /Users/<username>/Library/Application Support/Knowledge/
	if [ -f "/Users/${i}/Library/Application Support/Knowledge/knowledgeC.db" ]; then
        #Copy knowledgeC database file(s) for each user
		echo -e "\nCommand Run: cp -rf /Users/${i}/Library/Application Support/Knowledge ${computername}/LiveResponseData/CopiedFiles/${i}" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cp -rf "/Users/${i}/Library/Application Support/Knowledge" ${computername}/LiveResponseData/CopiedFiles/${i}
	else
		echo -e "** File /Users/${i}/Library/Application Support/Knowledge/knowledgeC.db does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi

	# Copying Sidebar List plist, found under /Users/<username>/Library/Preferences/com.apple.sidebarlists.plist
	if [ -f "/Users/${i}/Library/Preferences/com.apple.sidebarlists.plist" ]; then
        #Copy Sidebar List plist for each user
		echo -e "\nCommand Run: cp -f /Users/${i}/Library/Preferences/com.apple.sidebarlists.plist ${computername}/LiveResponseData/CopiedFiles/${i}" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cp -f "/Users/${i}/Library/Preferences/com.apple.sidebarlists.plist" ${computername}/LiveResponseData/CopiedFiles/${i}
	else
		echo -e "** File /Users/${i}/Library/Preferences/com.apple.sidebarlists.plist does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi

	# Copying Finder plist, found under /Users/<username>/Library/Preferences/com.apple.finder.plist
	if [ -f "/Users/${i}/Library/Preferences/com.apple.finder.plist" ]; then
        #Copy Finder plist for each user
		echo -e "\nCommand Run: cp -f /Users/${i}/Library/Preferences/com.apple.finder.plist ${computername}/LiveResponseData/CopiedFiles/${i}" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cp -f "/Users/${i}/Library/Preferences/com.apple.finder.plist" ${computername}/LiveResponseData/CopiedFiles/${i}
	else
		echo -e "** File /Users/${i}/Library/Preferences/com.apple.finder.plist does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi

	# Shared File List /Users/<username>/Library/Application Support/com.apple.sharedfilelist/
	if [ -d "/Users/${i}/Library/Application Support/com.apple.sharedfilelist" ]; then
		echo -e "\nCommand Run: cp -rf /Users/${i}/Library/Application Support/com.apple.sharedfilelist ${computername}/LiveResponseData/CopiedFiles/${i}" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cp -rf "/Users/${i}/Library/Application Support/com.apple.sharedfilelist" ${computername}/LiveResponseData/CopiedFiles/${i}
	else
		echo -e "** Directory /Users/${i}/Library/Application Support/com.apple.sharedfilelist does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi

	# bash_sessions, copying all files found under /Users/<username>/.bash_sessions
	if [ -d "/Users/${i}/.bash_sessions" ]; then
        #Copy .bash_sessions file(s) for each user
		echo -e "\nCommand Run: cp -rf /Users/${i}/.bash_sessions ${computername}/LiveResponseData/CopiedFiles/${i}" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cp -rf "/Users/${i}/.bash_sessions" ${computername}/LiveResponseData/CopiedFiles/${i}
	else
		echo -e "\n** Directory /Users/${i}/.bash_sessions does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi
	
	# Copying ssh known hosts file, found under /Users/<username>/.ssh/known_hosts
	if [ -f "/Users/${i}/.ssh/known_hosts" ]; then
        #Copy known_hosts file for each user
		echo -e "\nCommand Run: cp -f /Users/${i}/.ssh/known_hosts ${computername}/LiveResponseData/CopiedFiles/${i}" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cp -f "/Users/${i}/.ssh/known_hosts" ${computername}/LiveResponseData/CopiedFiles/${i}
	else
		echo -e "** File /Users/${i}/.ssh/known_hosts does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi
	
	# LSQuarantine events, copying LSQuarantine file found under /Users/<username>/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2
	if [ -f "/Users/${i}/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2" ]; then
        #Copy LSQuarantine file for each user
		echo -e "\nCommand Run: cp -f /Users/${i}/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2 ${computername}/LiveResponseData/CopiedFiles/${i}" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cp -f "/Users/${i}/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2" ${computername}/LiveResponseData/CopiedFiles/${i}
	else
		echo -e "\n** File /Users/${i}/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2 does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi
	
	#Web Browser data collection. We can add more as needed
	#Firefox
	if [ -d "/Users/${i}/Library/Application Support/Firefox/Profiles" ]; then
        echo -e "\nCommand Run: mkdir -p ${computername}/LiveResponseData/CopiedFiles/${i}/Firefox" | tee -a "${computername}/${computername}""_Processing_Details.txt"
        mkdir -p ${computername}/LiveResponseData/CopiedFiles/${i}/Firefox
		echo -e "\nCommand Run: cp -rf /Users/${i}/Library/Application Support/Firefox/Profiles/* ${computername}/LiveResponseData/CopiedFiles/${i}/Firefox" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cp -rf "/Users/${i}/Library/Application Support/Firefox/Profiles/"* ${computername}/LiveResponseData/CopiedFiles/${i}/Firefox
	else
		echo -e "** Directory /Users/${i}/Library/Application Support/Firefox/Profiles/ does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi	
	#Chrome
	if [ -d "/Users/${i}/Library/Application Support/Google/Chrome" ]; then
        echo -e "\nCommand Run: mkdir -p ${computername}/LiveResponseData/CopiedFiles/${i}/Chrome" | tee -a "${computername}/${computername}""_Processing_Details.txt"
        mkdir -p ${computername}/LiveResponseData/CopiedFiles/${i}/Chrome
		echo -e "\nCommand Run: cp -rf /Users/${i}/Library/Application Support/Google/Chrome/* ${computername}/LiveResponseData/CopiedFiles/${i}/Chrome" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cp -rf "/Users/${i}/Library/Application Support/Google/Chrome/"* ${computername}/LiveResponseData/CopiedFiles/${i}/Chrome
	else
		echo -e "** Directory /Users/${i}/Library/Application Support/Google/Chrome/ does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi		
	#Safari
	if [ -d "/Users/${i}/Library/Safari" ]; then
        echo -e "\nCommand Run: mkdir -p ${computername}/LiveResponseData/CopiedFiles/${i}/Safari" | tee -a "${computername}/${computername}""_Processing_Details.txt"
        mkdir -p ${computername}/LiveResponseData/CopiedFiles/${i}/Safari
		echo -e "\nCommand Run: cp -rf /Users/${i}/Library/Safari/* ${computername}/LiveResponseData/CopiedFiles/${i}/Safari" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cp -rf "/Users/${i}/Library/Safari/"* ${computername}/LiveResponseData/CopiedFiles/${i}/Safari
	else
		echo -e "** Directory /Users/${i}/Library/Safari/ does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi	
	#Tor Browser
	if [ -d "/Users/${i}/Library/Application Support/TorBrowser-Data/" ]; then
        echo -e "\nCommand Run: mkdir -p ${computername}/LiveResponseData/CopiedFiles/${i}/TorBrowser" | tee -a "${computername}/${computername}""_Processing_Details.txt"
        mkdir -p ${computername}/LiveResponseData/CopiedFiles/${i}/TorBrowser
		echo -e "\nCommand Run: cp -rf /Users/${i}/Library/Application Support/TorBrowser-Data/* ${computername}/LiveResponseData/CopiedFiles/${i}/TorBrowser" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cp -rf "/Users/${i}/Library/Application Support/TorBrowser-Data/"* ${computername}/LiveResponseData/CopiedFiles/${i}/TorBrowser
	else
		echo -e "** Directory /Users/${i}/Library/Application Support/TorBrowser-Data/ does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi	
	#Brave Browser
	if [ -d "/Users/${i}/Library/Application Support/BraveSoftware/" ]; then
        echo -e "\nCommand Run: mkdir -p ${computername}/LiveResponseData/CopiedFiles/${i}/Brave" | tee -a "${computername}/${computername}""_Processing_Details.txt"
        mkdir -p ${computername}/LiveResponseData/CopiedFiles/${i}/Brave
		echo -e "\nCommand Run: cp -rf /Users/${i}/Library/Application Support/BraveSoftware/* ${computername}/LiveResponseData/CopiedFiles/${i}/Brave" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cp -rf "/Users/${i}/Library/Application Support/BraveSoftware/"* ${computername}/LiveResponseData/CopiedFiles/${i}/Brave
	else
		echo -e "** Directory /Users/${i}/Library/Application Support/BraveSoftware/ does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi
	#Opera Browser
	if [ -d "/Users/${i}/Library/Application Support/com.operasoftware.Opera/" ]; then
        echo -e "\nCommand Run: mkdir -p ${computername}/LiveResponseData/CopiedFiles/${i}/Opera" | tee -a "${computername}/${computername}""_Processing_Details.txt"
        mkdir -p ${computername}/LiveResponseData/CopiedFiles/${i}/Opera
		echo -e "\nCommand Run: cp -rf /Users/${i}/Library/Application Support/com.operasoftware.Opera/* ${computername}/LiveResponseData/CopiedFiles/${i}/Opera" | tee -a "${computername}/${computername}""_Processing_Details.txt"
		cp -rf "/Users/${i}/Library/Application Support/com.operasoftware.Opera/"* ${computername}/LiveResponseData/CopiedFiles/${i}/Opera
	else
		echo -e "** Directory /Users/${i}/Library/Application Support/com.operasoftware.Opera/ does not exist ***" | tee -a "${computername}/${computername}""_Processing_Details.txt"
	fi	

	# User spotlight database (found on MacOS 10.14) #Putting this in, however, it will not work due to the Mojave access issues
#	if [ -d "/Users/${i}/Library/Metadata/CoreSpotlight/index.spotlight" ]; then
#        #Copy Spotlight store.db and .store.db file(s) for each user
#		echo -e "\nCommand Run: cp -rf /Users/${i}/Library/Metadata/CoreSpotlight/index.spotlghtV3/store.db ${computername}/LiveResponseData/CopiedFiles/${i}" | tee -a "${computername}/${computername}""_Processing_Details.txt"
#		echo -e "\nCommand Run: cp -rf /Users/${i}/Library/Metadata/CoreSpotlight/index.spotlghtV3/.store.db ${computername}/LiveResponseData/CopiedFiles/${i}" | tee -a "${computername}/${computername}""_Processing_Details.txt"
#		cp -rf "/Users/${i}/Library/Metadata/CoreSpotlight/index.spotlghtV3/store.db" ${computername}/LiveResponseData/CopiedFiles/${i}
#		cp -rf "/Users/${i}/Library/Metadata/CoreSpotlight/index.spotlghtV3/.store.db" ${computername}/LiveResponseData/CopiedFiles/${i}
#	else

done

echo ""
echo -e "** Completed running ${modulename} module **\n" | tee -a "${computername}/${computername}""_Processing_Details.txt"
echo ""
return
