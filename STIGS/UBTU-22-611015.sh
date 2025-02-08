<<COMMENT
.SYNOPSIS
    This Bash script ensures that Ubuntu 22.04 LTS enforces password complexity by requiring at least one lowercase character be used.
.NOTES
    Author          : Tim Ballada
    LinkedIn        : linkedin.com/in/timballada
    GitHub          : github.com/timballada
    Date Created    : 2025-02-07
    Last Modified   : 2025-02-07
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : UBTU-22-611015
    
.USAGE
    Put any usage instructions here.
    Example syntax:
    example@linux-terminal:~$ chmod +x UBTU-22-611015.sh
    example@linux-terminal:~$ sudo ./UBTU-22-611015.sh
COMMENT

#!/bin/bash                                                                                     
#                                                                                     
# This script enforces password complexity by ensuring that the configuration                                                                                     
# parameter "lcredit" in /etc/security/pwquality.conf is set to "-1".                                                                                                                                                                         
# If the file does not exist, it will be created with the required line.                                                                                     
# If the parameter exists (even if commented out), it will be updated.                                                                                                                                                                         
# Usage: Run this script as root or via sudo.                                                                                                                                                                          
                                                                                     
set -e                                                                                     
                                                                                     
PW_CONF="/etc/security/pwquality.conf"                                                                                     
DESIRED_LINE='lcredit = -1'                                                                                     
                                                                                     
# Check if the file exists; if not, create it with the desired configuration.                                                                                     
if [ ! -f "$PW_CONF" ]; then                                                                                     
            echo "File $PW_CONF not found. Creating file with the required configuration." 
                echo "$DESIRED_LINE" > "$PW_CONF" 
                    exit 0 
fi 
                                                                                     
# Determine if the file already contains an occurrence of "lcredit"                                                                                     
if grep -Eiq '^\s*#?\s*lcredit\s*=' "$PW_CONF"; then                                                                                     
            # Use sed to update all occurrences (commented or not) to the desired configuration.                                                                                     
                sed -i -E "s/^\s*#?\s*lcredit\s*=.*/$DESIRED_LINE/" "$PW_CONF"                                                                                     
                    echo "Updated lcredit in $PW_CONF to '-1'."                                                                                     
            else                                                                                     
                        # If no lcredit line is found, append the desired configuration.                                                                                     
                            echo "$DESIRED_LINE" >> "$PW_CONF"                                                                                     
                                echo "Added '$DESIRED_LINE' to $PW_CONF."                                                                                     
fi                                                                                     
                                                                                     
exit 0
