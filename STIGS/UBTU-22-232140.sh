<<COMMENT
.SYNOPSIS
    This Bash script ensures that Ubuntu 22.04 LTS is configured so that the "journalctl" command is not accessible by unauthorized users.
.NOTES
    Author          : Tim Ballada
    LinkedIn        : linkedin.com/in/timballada
    GitHub          : github.com/timballada
    Date Created    : 2025-02-07
    Last Modified   : 2025-02-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : UBTU-22-232140
    
.USAGE
    Put any usage instructions here.
    Example syntax:
    example@linux-terminal:~$ chmod +x UBTU-22-232140.sh
    example@linux-terminal:~$ sudo ./UBTU-22-232140.sh
COMMENT

#!/bin/bash
#
# This script ensures that /usr/bin/journalctl has the permission set to 740.
# This configuration prevents unauthorized users from accessing journalctl.
# Usage: Run this script as root or via sudo.

# Ensure the script is run as root.
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Use sudo."
        exit 1
fi

JOURNALCTL="/usr/bin/journalctl"

# Check if journalctl exists.
if [ ! -f "$JOURNALCTL" ]; then
    echo "Error: $JOURNALCTL does not exist."
        exit 1
fi

# Retrieve the current permission of journalctl.
current_perm=$(stat -c "%a" "$JOURNALCTL")
echo "Current permissions for $JOURNALCTL: $current_perm"

# Check if the permission is set to 740.
if [ "$current_perm" = "740" ]; then
    echo "Permissions are already correctly set to 740."
    else
        echo "Setting permissions to 740..."
    chmod 740 "$JOURNALCTL"
        
        # Verify the change.
    new_perm=$(stat -c "%a" "$JOURNALCTL")
        if [ "$new_perm" = "740" ]; then
        echo "Successfully set permissions to 740."
    else
            echo "Error: Failed to set permission
s on $JOURNALCTL." >&2
            exit 1
        fi
fi

exit 0
