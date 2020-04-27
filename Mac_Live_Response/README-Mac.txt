Last updated 11 April 2019 by Brian Moran (brian@brimorlabs.com)
Please read "ReadMe.txt" for more information regarding GPL, the script itself, and changes
RELEASE DATE: 20190411
AUTHOR: Brian Moran (brian@brimorlabs.com)
TWITTER: BriMor Labs (@BriMorLabs)
Version: Live Response Collection (Cedarpelta Build - 20190411)
Copyright: 2013-2019, Brian Moran

This file is part of the Live Response Collection
The Live Response Collection is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
Additionally, usages of all tools fall under the express license agreement stated by the tool itself.
In the event that this tool is utilized by a company providing digital forensics/incident response services, other than BriMor Labs, without written consent from BriMor Labs, implies that the user/company agrees to pay the sum of five million dollars annually on January 1 of every year, for 10 years, to Brian Moran.



THE INFORMING INFORMATION SECTION:
This is meant to be a collection of tools used to gather and triage data from a live OSX system.

Running the script of your choice, "Complete_OSX_Live_Response.sh", "Memory_Dump_OSX_Live_Response.sh", or "Triage_OSX_Live_Response.sh" from a terminal window will allow the script to collect data from live system running an OSX/MacOS operating system. If run with administrator privileges (sudo) it will collect more information. Administrator privileges are required if you want to automate the creation of a disk image and/or memory dump. The script will automatically skip the creation of a memory dump and/or a disk image if SIP is detected.




AUTHOR NOTE: I would like to extend a very special "Thank you" to Mari DeGrazia (@maridegrazia), Adrian Leong (@Cheeky4n6Monkey), Ken Pryor (@KDPryor), Josh Madeley (@MadeleyJosh), Roberta Payne (@robertapayne_1), Brad Garnett (@brgarnett), Sarah Edwards (@iamevltwin), Luca Pugliese (@lupug), Alexis Wells, Kevin Pagano (@KevinPagano3), Mark McKinnon (@markmckinnon), Tom Yarrish (@CdtDelta), Cristina Roura, Mitch Impey (@grumpy4n6), Jonathon Poling (@jpoforenso), Darcy Adefehinti (@regaindata), and Kirstie Failey (@Gigs_Security) for their extensive testing and valuable feedback to make this tool what it is today!




-----CHANGES-----
20190411 - Cedarpelta public release
20190322 - Added Unified Log collection, known_hosts, .out log files, LSQuarantine Events, and browser history (Chrome, Firefox, Tor Browser, Brave, and Safari (Safari may not be collected on Mojave though) (at the request of Kirstie (@Gigs_Security))
20190308 - Included with Cedarpelta demo build for testing
20181004 - Made small changes for Mojave, specifically with regards to permissions for file copying and such
20180907 - Cedarpelta rewrite, out for beta testing again
20180808 - Cedarpelta Build out for beta testing
20161212 - Bambiraptor Build public release
20161030 - Bambiraptor Build out for beta testing
20160112 - Allosaurus Build released
20160108 - Added fseventsd collection
20151224 - Added output parsing to try to eliminate non numeric characters in command output since OSX follows no standards with regards to data output
20151109 - Added memory dump extraction, added modules (similar to Windows Live Response Collection). Added logging file. Many changes to resemble the Windows Live Response Collection. Added change to volume mapping and free size computation to work with external drives attached with the same name and account for spaces in drive name (Thanks @CdtDelta)!
20150320 - Due to a coding oversight, I forgot to put "LiveResponseData" in the file path. Thanks very much to Cristina Roura for pointing that out!
20150319 - Added automated MD5 and SHA256 file hashing of all output files, saved as “Processing_Details_and_Hashes.txt
