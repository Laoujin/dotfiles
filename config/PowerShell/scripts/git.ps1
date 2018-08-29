Import-Module Posh-Git


# Change colors
# Posh-Git v0.x
# $global:GitPromptSettings.WorkingForegroundColor = [ConsoleColor]::Yellow
# $global:GitPromptSettings.BranchForegroundColor = [ConsoleColor]::Green

$global:gitStatusNumbers

function Git-NumberedStatus() {
	$global:gitStatusNumbers = git status -s | % {
		$file = $_.Substring(3)

		$staged = $_[1] -eq " "
		$state = If ($staged) {$_[0]} Else {$_[1]}
		$state = If ($state -eq "??") {"A"} Else {$state}
		return @{state=$state;file=$file;staged=$staged}
	}

	$stagedFiles = $global:gitStatusNumbers | Where staged
	if ($stagedFiles.length) {
		Write-Host "Staged files:"
		$stagedFiles | % {
			Write-Host "    $($_.state) $($_.file)" -ForegroundColor green
		}
		Write-Host ""
	}

	$global:gitStatusNumbers = @($global:gitStatusNumbers | Where {$_.staged -eq $false})
	if ($global:gitStatusNumbers.length) {
		Write-Host "Working directory:"
		$global:gitStatusNumbers | % {$index = -1}{
			$index++

			$color = switch($_.state) {
				'A' {'Blue'; break}
				'M' {'Yellow'; break}
				'D' {'DarkMagenta'; break}
				default {'White'}
			}
			Write-Host "$index   $($_.state) $($_.file)" -ForegroundColor $color
		}
	}
}


function Git-NumberedAdd($index) {
	# TODO: need to accept 0-3
	# TODO: need to accept 0 1 5 4 7
	# TODO: need to accept <4 and >8 ?
	# TODO: need to quote files
	$info = $global:gitStatusNumbers[$index]
	git add $info.file
	Write-Host "Added $index $($info.file)"
}

Set-Alias gs Git-NumberedStatus
Set-Alias ga Git-NumberedAdd


# Posh-Git v1.x
# Update-Module Posh-Git -RequiredVersion 1.0.0-beta2 -AllowPrerelease

# Interprets colors with System.Drawing.ColorTranslator.FromHtml()
# But available colors are only: [ConsoleColor].GetEnumNames()
# Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, DarkGray
# Gray, Blue, Green, Cyan, Red, Magenta, Yellow, White
$GitPromptSettings.DefaultPromptPath.ForegroundColor = 'White'

$GitPromptSettings.LocalWorkingStatusSymbol.ForegroundColor = 'Yellow'
$GitPromptSettings.WorkingColor.ForegroundColor = 'Yellow'

$GitPromptSettings.BranchAheadStatusSymbol.ForegroundColor = 'Green'
$GitPromptSettings.BranchBehindStatusSymbol.ForegroundColor = 'DarkMagenta'
$GitPromptSettings.BranchBehindAndAheadStatusSymbol.ForegroundColor = 'Yellow'


# Prompt Shrinkers
$shrinkersPath = Join-Path $PSScriptRoot "..\prompt-aliases.ini"
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


# I can't type
Set-Alias gt git
Set-Alias gut git
Set-Alias gti git
Set-Alias got git
Set-Alias guit git
Set-Alias giut git
