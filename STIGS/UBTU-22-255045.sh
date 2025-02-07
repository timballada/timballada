







#!/bin/bash
# fix_x11uselocalhost.sh
# This script ensures that X11UseLocalhost is set to "yes" in /etc/ssh/sshd_config
# to prevent remote hosts from connecting to the SSH X11 proxy display.
#
# STIG ID: UBTU-22-255045

# Exit immediately if a command exits with a non-zero status.
set -e

CONFIG_FILE="/etc/ssh/sshd_config"

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "[-] This script must be run as root. Please run with sudo or as root."
  exit 1
fi

# Verify that the sshd_config file exists.
if [ ! -f "$CONFIG_FILE" ]; then
  echo "[-] Error: $CONFIG_FILE not found."
  exit 1
fi

# Create a timestamped backup of the current sshd_config.
BACKUP_FILE="${CONFIG_FILE}.bak.$(date +%F-%T)"
echo "[*] Backing up $CONFIG_FILE to $BACKUP_FILE"
cp "$CONFIG_FILE" "$BACKUP_FILE"

# Modify any existing X11UseLocalhost lines.
# The regex looks for lines with optional whitespace and an optional leading "#"
# and replaces the entire line with "X11UseLocalhost yes".
if grep -q -E '^\s*#?\s*X11UseLocalhost' "$CONFIG_FILE"; then
  echo "[*] Found existing X11UseLocalhost configuration. Updating it to 'yes'."
  sed -i -r 's/^\s*#?\s*(X11UseLocalhost).*$/\1 yes/' "$CONFIG_FILE"
else
  echo "[*] No existing X11UseLocalhost configuration found. Appending the setting."
  {
    echo ""
    echo "# Added to comply with STIG UBTU-22-255045"
    echo "X11UseLocalhost yes"
  } >> "$CONFIG_FILE"
fi

# Verify that the configuration now contains the correct setting.
if grep -q -E '^\s*X11UseLocalhost\s+yes' "$CONFIG_FILE"; then
  echo "[+] The SSH configuration now contains 'X11UseLocalhost yes'."
else
  echo "[-] Error: Failed to update the SSH configuration."
  exit 1
fi

# Restart the SSH daemon to apply changes.
echo "[*] Restarting the SSH daemon..."
systemctl restart sshd.service

# Check if the SSH daemon restarted successfully.
if systemctl is-active --quiet sshd.service; then
  echo "[+] SSH daemon restarted successfully."
else
  echo "[-] Error: SSH daemon failed to restart."
  exit 1
fi

exit 0
