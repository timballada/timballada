<<COMMENT
.SYNOPSIS
    This Bash script ensures that Ubuntu 22.04 LTS is configured so that remote X connections are disabled, unless to fulfill documented and validated mission requirements.
.NOTES
    Author          : Tim Ballada
    LinkedIn        : linkedin.com/in/timballada
    GitHub          : github.com/timballada
    Date Created    : 2025-02-07
    Last Modified   : 2025-02-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : UBTU-22-255040
    
.USAGE
    Put any usage instructions here.
    Example syntax:
    example@linux-terminal:~$ chmod +x UBTU-22-255040.sh
    example@linux-terminal:~$ sudo ./UBTU-22-255040.sh
COMMENT

#!/bin/bash
#
# This script configures Ubuntu 22.04 LTS to disable remote X connections by
# ensuring that the SSH daemon configuration (/etc/ssh/sshd_config) includes
# the line:
#     X11Forwarding no
# If an existing X11Forwarding directive is found (even if commented out), it is
# updated to "no". If it is missing, the directive is appended to the file.
# After modifying the configuration, the script restarts the SSH daemon.
# Usage: Run this script as root or via sudo.

set -e

# Verify that the script is executed with root privileges.
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root. Try running with sudo."
        exit 1
fi

SSHD_CONFIG="/etc/ssh/sshd_config"

# Check if the sshd configuration file exists.
if [ ! -f "$SSHD_CONFIG" ]; then
    echo "Error: $SSHD_CONFIG not found. Aborting."
        exit 1
fi

echo "Modifying $SSHD_CONFIG to disable X11 forwarding..."

# Check if any line setting X11Forwarding exists (including commented-out ones).
if grep -Eiq "^\s*#?\s*X11Forwarding" "$SSHD_CONFIG"; then
    # Update any existing occurrence to "X11Forwarding no".
        sed -i -r 's/^\s*#?\s*X11Forwarding\s+.*/X11Forwarding no/' "$SSHD_CONFIG"
    echo "Updated existing X11Forwarding setting to 'no'."
    else
        # Append the directive if it doesn't exist.
    echo -e "\nX11Forwarding no" >> "$SSHD_CONFIG"
        echo "Appended 'X11Forwarding no' to $SSHD_CONFIG."
fi

# Restart the SSH daemon to apply the changes.
echo "Restarting SSH daemon..."
systemctl restart sshd.service

# Verify that the SSH daemon is active.
if systemctl is-active --quiet sshd.service; then
    echo "SSH daemon restarted successfully. X11 forwarding is now disabled."
    else
        echo "Error: SSH daemon did not restart successfully." >&2
    exit 1
fi

exit 0
