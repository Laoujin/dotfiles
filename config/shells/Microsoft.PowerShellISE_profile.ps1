Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

. ".\Microsoft.PowerShell_profile.ps1"

Pop-Location
