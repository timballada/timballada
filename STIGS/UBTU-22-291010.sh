<<COMMENT
.SYNOPSIS
    This Bash script ensures that Ubuntu 22.04 LTS disables automatic mounting of Universal Serial Bus (USB) mass storage driver.
    
.NOTES
    Author          : Tim Ballada
    LinkedIn        : linkedin.com/in/timballada
    GitHub          : github.com/timballada
    Date Created    : 2025-03-19
    Last Modified   : 2025-03-19
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : UBTU-22-291010
    
.USAGE
    Put any usage instructions here.
    Example syntax:
    example@linux-terminal:~$ chmod +x UBTU-22-291010.sh
    example@linux-terminal:~$ sudo ./UBTU-22-291010.sh
COMMENT

#!/bin/bash
# STIG: UBTU-22-291010 - Disable USB mass storage driver on Ubuntu 22.04 LTS

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "Error: This script must be run as root. Use sudo."
  exit 1
fi

STIG_CONF="/etc/modprobe.d/stig.conf"

echo "Configuring Ubuntu 22.04 LTS to disable USB mass storage driver..."

# Append the required line for disabling module loading if not already present
if ! grep -q "^install usb-storage /bin/false" "$STIG_CONF" 2>/dev/null; then
    echo "install usb-storage /bin/false" >> "$STIG_CONF"
    echo "Added: install usb-storage /bin/false"
else
    echo "Line 'install usb-storage /bin/false' already exists."
fi

# Append the required blacklist line if not already present
if ! grep -q "^blacklist usb-storage" "$STIG_CONF" 2>/dev/null; then
    echo "blacklist usb-storage" >> "$STIG_CONF"
    echo "Added: blacklist usb-storage"
else
    echo "Line 'blacklist usb-storage' already exists."
fi

# Update the initramfs to apply changes
echo "Updating initramfs..."
update-initramfs -u

echo "Configuration complete. USB mass storage driver has been disabled."
