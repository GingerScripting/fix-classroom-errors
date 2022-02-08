# fix-classroom-errors
Fixes errors in Apple Classroom by pulling down a new EDU profile

## How to Use:
1. Create a Jamf service account that has these privileges:
- Read – Classes
- Update – Classes
- Read – Advanced Mobile Device Searches
- Read – Mobile Devices
- Update – Mobile Devices
- Update – Users
2. Hardcode the variables in the script with the credentials for the service account, Jamf Pro URL, and search and class ID numbers.
3. Make sure the script is named fixCertificates.sh and move it to the /usr/local folder.
4. Save the LaunchDaemon as com.isd701.fixcertificates.plist and move it to the /Library/LaunchDaemons folder.
5. Run these commands (with sudo):
    - chmod +x /usr/local/fixCertificates.sh
    - chown root /Library/LaunchDaemons/com.isd701.fixcertificates.plist
    - chgrp wheel /Library/LaunchDaemons/com.isd701.fixcertificates.plist
    - launchctl load /Library/LaunchDaemons/com.isd701.fixcertificates.plist

That’s it. The LaunchDaemon will run every day at 8 am until you remove the /Library/LaunchDaemons/com.isd701.fixcertificates.plist file! All logging will go to the /var/log/fixCertificates (standard out) and /var/log/fixCertificatesErr.log (standard error).
