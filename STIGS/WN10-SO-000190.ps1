<#
.SYNOPSIS
    This PowerShell script ensures that Kerberos encryption types are configured to prevent the use of DES and RC4 encryption suites.

.NOTES
    Author          : Tim Ballada
    LinkedIn        : https://www.linkedin.com/in/tim-ballada-25443431a/
    GitHub          : github.com/timballada
    Date Created    : 2025-01-31
    Last Modified   : 2025-01-31
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000190

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\WN10-SO-000190.ps1 
#>

# Define variables
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters"
$propertyName = "SupportedEncryptionTypes"
$propertyValue = 0x7FFFFFF8  # 2147483640 in decimal

# Ensure the registry path exists
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry property using the variables
Set-ItemProperty -Path $registryPath -Name $propertyName -Value $propertyValue -Type DWord -Force

# Confirm the change
Write-Output "Registry key '$propertyName' successfully set to $propertyValue."
