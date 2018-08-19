Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)


if (Test-Path ".\auto-print.txt") {
	Write-Output (Get-Content ".\auto-print.txt")
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


# Load all ps1
Get-Childitem .\dotfiles -Filter *.ps1 -Recurse | Foreach-Object { . $_.FullName }

Pop-Location

Start-SshAgent -Quiet
