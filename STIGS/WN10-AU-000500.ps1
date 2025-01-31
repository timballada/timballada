<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Tim Ballada
    LinkedIn        : https://www.linkedin.com/in/tim-ballada-25443431a/
    GitHub          : github.com/timballada
    Date Created    : 2025-01-30
    Last Modified   : 2025-01-30
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000500

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\WN10-AU-000500.ps1 
#>


# Define variables
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
$propertyName = "MaxSize"
$propertyValue = 0x8000  # 32768 in decimal

# Ensure the registry path exists
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry property using the variables
Set-ItemProperty -Path $registryPath -Name $propertyName -Value $propertyValue -Type DWord -Force

# Confirm the change
Write-Output "Registry key '$propertyName' successfully set to $propertyValue."
