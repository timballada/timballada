<#
.SYNOPSIS
    This PowerShell script ensures that the system is configured to prevent anonymous users 
    from having the same rights as the Everyone group.

.NOTES
    Author          : Tim Ballada
    LinkedIn        : https://www.linkedin.com/in/tim-ballada-25443431a/
    GitHub          : github.com/timballada
    Date Created    : 2025-01-31
    Last Modified   : 2025-01-31
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000160

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\WN10-SO-000160.ps1 
#>

# Define variables
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$propertyName = "everyoneincludesanonymous"
$propertyValue = 0  # 0x00000000 in hexadecimal

# Ensure the registry path exists
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry property using the variables
Set-ItemProperty -Path $registryPath -Name $propertyName -Value $propertyValue -Type DWord -Force

# Confirm the change
Write-Output "Registry key '$propertyName' successfully set to $propertyValue."
