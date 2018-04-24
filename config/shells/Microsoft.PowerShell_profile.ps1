Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

Write-Output (Get-Content ".\PowerShell\_learnthis.txt")

if (Test-Path ".\Microsoft.PowerShell_aliases.ps1") {
	. ".\Microsoft.PowerShell_aliases.ps1"
}

# Fix: more/less only pageup/down works?


# --> transed / transde: also get synonyms
# --> npm open package-name --> open Github in browser
# .. confac/... -> allow to go to somewhere directly as argument


# More colorblindness fun:
# or Get-Host or $Host.UI.RawUI
$host.PrivateData.ErrorBackgroundColor = 'Red'
$host.PrivateData.ErrorForegroundColor = 'Yellow' # or: "DarkMagenta"


# ErrorForegroundColor    : Red
# ErrorBackgroundColor    : Black
# WarningForegroundColor  : Yellow
# WarningBackgroundColor  : Black
# DebugForegroundColor    : Yellow
# DebugBackgroundColor    : Black
# VerboseForegroundColor  : Yellow
# VerboseBackgroundColor  : Black
# ProgressForegroundColor : Yellow
# ProgressBackgroundColor : DarkCyan

. ".\PowerShell\envpath.ps1"
. ".\PowerShell\envpath_mod.ps1"
. ".\PowerShell\filesystem.ps1"

. ".\PowerShell\prompt_git.ps1"
. ".\PowerShell\prompt_readline.ps1"
. ".\PowerShell\other.ps1"

# Fix: PS startup error...
# Import-Module '.\Modules\Jump.Location\Jump.Location.psd1'
# TODO: need better jump.location...

Pop-Location

Start-SshAgent -Quiet