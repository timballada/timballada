<<COMMENT
.SYNOPSIS
    This Bash script ensures that Ubuntu 22.04 LTS is configured so that the Advance Package Tool (APT) prevents the installation of patches, service packs, device drivers,
    or operating system components without verification they have been digitally signed using a certificate that is recognized and approved by the organization.
.NOTES
    Author          : Tim Ballada
    LinkedIn        : linkedin.com/in/timballada
    GitHub          : github.com/timballada
    Date Created    : 2025-02-07
    Last Modified   : 2025-02-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : UBTU-22-214010
    
.USAGE
    Put any usage instructions here.
    Example syntax:
    example@linux-terminal:~$ chmod +x UBTU-22-214010.sh
    example@linux-terminal:~$ sudo ./UBTU-22-214010.sh
COMMENT

#!/bin/bash
#
# This script configures APT so that it does not allow the installation of
# patches, service packs, device drivers, or OS components unless they have been
# digitally signed with an approved certificate.
# It ensures that the setting:
#   APT::Get::AllowUnauthenticated "false";
# is present in at least one configuration file in /etc/apt/apt.conf.d/.
# Usage: Run this script as root or via sudo.

set -e

# Flag to track whether the configuration line was found in any file.
found=0

# Loop through each file in the apt configuration directory.
for file in /etc/apt/apt.conf.d/*; do
    # Check if the file contains the setting (even if commented out)
    if grep -q "APT::Get::AllowUnauthenticated" "$file"; then
        # Use sed to:
        #   - Remove any leading '#' (i.e. uncomment if necessary)
        #   - Replace any current value with "false"
        # This covers lines such as:
        #   #APT::Get::AllowUnauthenticated "true";
        #   APT::Get::AllowUnauthenticated "true";
        #   APT::Get::AllowUnauthenticated "false"; (which remains unchanged)
        sed -i -r 's/^\s*#?\s*(APT::Get::AllowUnauthenticated\s+)"[^"]*";/\1"false";/' "$file"
        echo "Updated $file: set APT::Get::AllowUnauthenticated to \"false\"."
        found=1
    fi
done

# If none of the configuration files contained the setting,
# create a new configuration file to enforce it.
if [ "$found" -eq 0 ]; then
    config_file="/etc/apt/apt.conf.d/99-security-allowunauthenticated"
    echo 'APT::Get::AllowUnauthenticated "false";' > "$config_file"
    echo "Created $config_file with APT::Get::AllowUnauthenticated set to \"false\"."
fi

exit 0
