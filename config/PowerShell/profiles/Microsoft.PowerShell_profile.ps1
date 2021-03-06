Push-Location $PSScriptRoot

Write-Host "Running $Profile" -ForegroundColor Blue
Write-Host ""
Write-Host ""

# Load ps libs
Get-Childitem .\dotfiles\lib -Filter *.ps1 -Recurse | Foreach-Object {
	. $_.FullName
}

# Load all custom ps1 (except those for the PMC/nuget profile)
Get-Childitem .\dotfiles -Filter *.ps1 -Recurse | Foreach-Object {
	$containingDirName = Split-Path (Split-Path $_.FullName -Parent) -Leaf
	if ($containingDirName -ne "nuget" -and $containingDirName -ne "lib" -and (-not $_.FullName.EndsWith(".Tests.ps1"))) {
		. $_.FullName
	}
}


# Quick reference stuff
$autoPrintFile = "$PSScriptRoot\auto-print.md"
if (Test-Path $autoPrintFile) {
	Write-Host "Printing things to remember as defined in:" -ForegroundColor Blue
	Write-Host $autoPrintFile -ForegroundColor White

	$tempColor = [console]::ForegroundColor
	[console]::ForegroundColor = "DarkGray"
	Write-Output (Get-Content $autoPrintFile)
	[console]::ForegroundColor = $tempColor

	Write-Host ""
	Write-Host ""
}


# Set-Location Aliases
$aliasesPath = "$PSScriptRoot\cd-aliases.ini"
Write-Host "Creating Set-Location aliases as defined in:" -ForegroundColor Blue
Write-Host $aliasesPath -ForegroundColor White
Write-Host ""
if (Test-Path $aliasesPath) {
	$sections = Get-IniContent .\cd-aliases.ini
	$index = 0
	foreach ($section in $sections.keys) {
		$index = 0
		Write-Host "$($section): " -NoNewline -ForegroundColor White
		foreach ($alias in $sections.$section.keys) {
			$cd = $sections.$section.$alias
			Invoke-Expression "`${function:$alias} = { Set-Location `"$cd`" }"
			if ($index -gt 0) {
				Write-Host ", " -NoNewline -ForegroundColor White
			}
			Write-Host $alias -NoNewline -ForegroundColor Green
			$index++
			# $aliases += ", $alias"
		}
		Write-Host ""
		# Write-Host "" -NoNewline -ForegroundColor White
		# Write-Host "$($aliases.Substring(2))" -ForegroundColor Green
	}
	Write-Host "`n"
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
