Import-Module Posh-Git

### Change colors
# Posh-Git v0.x
# $global:GitPromptSettings.WorkingForegroundColor = [ConsoleColor]::Yellow
# $global:GitPromptSettings.BranchForegroundColor = [ConsoleColor]::Green


# Posh-Git v1.x
# Update-Module Posh-Git -RequiredVersion 1.0.0-beta2 -AllowPrerelease

# Interprets colors with System.Drawing.ColorTranslator.FromHtml()
# But available colors are only: [ConsoleColor].GetEnumNames()
# Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, DarkGray
# Gray, Blue, Green, Cyan, Red, Magenta, Yellow, White
$GitPromptSettings.DefaultPromptPath.ForegroundColor = 'White'

$GitPromptSettings.LocalWorkingStatusSymbol.ForegroundColor = 'Yellow'
$GitPromptSettings.WorkingColor.ForegroundColor = 'Yellow'
# $GitPromptSettings.BranchColor.ForegroundColor = 'Green'

$GitPromptSettings.BranchAheadStatusSymbol.ForegroundColor = 'Green'
$GitPromptSettings.BranchBehindStatusSymbol.ForegroundColor = 'Magenta'
$GitPromptSettings.BranchBehindAndAheadStatusSymbol.ForegroundColor = 'Yellow'


### Prompt Shrinkers
$shrinkersPath = Join-Path $PSScriptRoot "..\..\prompt-aliases.ini"
# Write-Host "Creating prompt shrinkers as defined in:" -ForegroundColor Blue
# Write-Host ([System.IO.Path]::GetFullPath($shrinkersPath)) -ForegroundColor White
$shrinkers = Get-IniContent $shrinkersPath
foreach ($shrinkTo in $shrinkers["Prompt-Shrinkers"].Keys) {
	$shrinkPath = $shrinkers["Prompt-Shrinkers"].$shrinkTo
	# echo "$shrinkTo -> $shrinkPath"
}


function Get-CustomPromptPath() {
	$currentDir = $pwd.Path
	foreach ($shrinkTo in $shrinkers["Prompt-Shrinkers"].Keys) {
		$shrinkPath = $shrinkers["Prompt-Shrinkers"].$shrinkTo
		if ($currentDir -eq $shrinkPath -or $currentDir.StartsWith("$shrinkPath\", "CurrentCultureIgnoreCase")) {
			$remainingPath = $currentDir.Substring($shrinkPath.Length)
			return "$shrinkTo$remainingPath"
		}
	}
	return $pwd
}


$GitPromptSettings.DefaultPromptPath.Text = '$(Get-CustomPromptPath)'

# function prompt {
#     $prompt = Write-Prompt "Before " -ForegroundColor ([ConsoleColor]::Green)
#     $prompt = & $GitPromptScriptBlock
#     $prompt += Write-Prompt "After" -ForegroundColor ([ConsoleColor]::Magenta)
#     if ($prompt) { "$prompt " } else { " " }
# }
