<<COMMENT
.SYNOPSIS
    This Bash script ensures that Ubuntu 22.04 LTS disables account identifiers (individuals, groups, roles, and devices) after 35 days of inactivity.
    
.NOTES
    Author          : Tim Ballada
    LinkedIn        : linkedin.com/in/timballada
    GitHub          : github.com/timballada
    Date Created    : 2025-02-07
    Last Modified   : 2025-02-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : UBTU-22-411035
    
.USAGE
    Put any usage instructions here.
    Example syntax:
    example@linux-terminal:~$ chmod +x UBTU-22-411035.sh
    example@linux-terminal:~$ sudo ./UBTU-22-411035.sh
COMMENT

#!/bin/bash
#
# This script ensures that Ubuntu 22.04 LTS disables account identifiers after
# 35 days of inactivity by setting the default inactive period for user accounts.
# It verifies the current default inactivity period using "useradd -D" and, if the
# period is not 35 days, updates the setting using:
#   useradd -D -f 35
# Usage: Run this script as root (or with sudo)

set -e

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Try using sudo."
    exit 1
fi

# Retrieve the current default inactivity value
current_inactive=$(useradd -D | grep "^INACTIVE=" | cut -d'=' -f2)

if [ "$current_inactive" = "35" ]; then
    echo "The default inactivity period is already set to 35 days."
else
    echo "Current default inactivity period is set to '${current_inactive:-not defined}'."
    echo "Setting the default inactivity period to 35 days..."
                        
    # Set the default inactivity period to 35 days
    useradd -D -f 35

    # Verify the change
    new_inactive=$(useradd -D | grep "^INACTIVE=" | cut -d'=' -f2)
    if [ "$new_inactive" = "35" ]; then
        echo "Successfully set the default inactivity period to 35 days."
    else
        echo "Error: Failed to set the default inactivity period."
        exit 1
    fi
fi

exit 0
