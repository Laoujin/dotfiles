Push-Location $PSScriptRoot

Write-Host "Running $Profile" -ForegroundColor Blue
echo ""
echo ""

# Load all ps1
Get-Childitem .\dotfiles -Filter *.ps1 -Recurse | Foreach-Object { . $_.FullName }


# Quick reference stuff
$autoPrintFile = "$PSScriptRoot\auto-print.md"
if (Test-Path $autoPrintFile) {
	Write-Host "Printing things to remember as defined in:" -ForegroundColor White
	Write-Host $autoPrintFile -ForegroundColor White
	Get-Content $autoPrintFile | Write-Host -ForegroundColor DarkGray
	echo ""
	echo ""
}


# Set-Location Aliases
$aliasesPath = "$PSScriptRoot\cd-aliases.ini"
Write-Host "Creating Set-Location aliases as defined in:" -ForegroundColor White
Write-Host $aliasesPath -ForegroundColor White
if (Test-Path $aliasesPath) {
	$aliases = Get-IniContent .\cd-aliases.ini

	$echo = ""
	foreach ($alias in $aliases["No-Section"].keys) {
		$cd = $aliases["No-Section"].$alias
		Invoke-Expression "`${function:$alias} = { Set-Location `"$cd`" }"
		$echo += ", $alias"
	}

	$echo = "Aliases: $($echo.Substring(2))`n`n"
	Write-Host $echo -ForegroundColor Green
}


Pop-Location


Start-SshAgent -Quiet


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
