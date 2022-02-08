#!/bin/bash

#Add your credentials and Jamf Pro URL here if you don't want to be prompted for them. This is also necessary if you are running the script as root (jamf or LaunchDaemon)
jssUser=
jssPassword=
jssURL=

#You can also uncomment this line if you want the script to read which jamf server the computer it is running on connects to.
#jssURL=$(/usr/bin/defaults read ~/Library/Preferences/com.jamfsoftware.jss.plist url)


if [ -z $jssURL ]; then
	echo "Please enter the JSS URL:"
	read -r jssURL
fi 

if [ -z $jssUser ]; then
	echo "Please enter your JSS username:"
	read -r jssUser
fi 

if [ -z $jssPassword ]; then 
	echo "Please enter JSS password for account: $jssUser:"
	read -r -s jssPassword
fi

#search number - you can fill in the search number here if you don't want to be prompted
searchNumber=
if [ -z $searchNumber ]; then
	echo "Please enter the number of the advanced computer search you want to send the command to:"
	read -r searchNumber
fi 

echo "Logging in to $jssURL as $jssUser"

xpath() {
    # the xpath tool changes in Big Sur
    if [[ $(sw_vers -buildVersion) > "20A" ]]; then
        /usr/bin/xpath -e "$@"
    else
        /usr/bin/xpath "$@"
    fi
}


userNames=($(curl -X GET -H "Accept: application/xml" -s -u "${jssUser}":"${jssPassword}" ${jssURL}/JSSResource/advancedmobiledevicesearches/id/$searchNumber | xpath "//mobile_device//Username" 2> /dev/null | awk -F'</?Username>' '{for(i=2;i<=NF;i++) print $i}'))

fixCertificate() {

curl -X PUT -H "Accept: application/xml" -H "Content-type: application/xml" -s -u "${jssUser}":"${jssPassword}" -d "<class><teachers><teacher>$name</teacher></teachers></class>" "${jssURL}/JSSResource/classes/id/6966" > /dev/null
sleep 10

}

for name in "${userNames[@]}"; do
#	echo "$name"
	fixCertificate
	echo "New EDU profile will be pulled down on iPad assigned to $name"
done
