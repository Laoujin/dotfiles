Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

if (Test-Path ".\Microsoft.PowerShell_aliases.ps1") {
	. ".\Microsoft.PowerShell_aliases.ps1"
}

. ".\PowerShell\envpath.ps1"
. ".\PowerShell\envpath_mod.ps1"
. ".\PowerShell\filesystem.ps1"
. ".\PowerShell\psreadline.ps1"

. ".\PowerShell\prompt.ps1"

Import-Module '.\Modules\Jump.Location\Jump.Location.psd1'

Pop-Location

Start-SshAgent -Quiet