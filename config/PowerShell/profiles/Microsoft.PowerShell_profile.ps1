Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

Write-Output (Get-Content ".\PowerShell\_learnthis.txt")

if (Test-Path ".\Microsoft.PowerShell_aliases.ps1") {
	. ".\Microsoft.PowerShell_aliases.ps1"
}

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


# Load all ps1 in .\PowerShell
Get-Childitem .\PowerShell -Filter *.ps1 -Recurse | Foreach-Object { . $_.FullName }

Pop-Location

Start-SshAgent -Quiet
