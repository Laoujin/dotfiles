$global:gitStatusNumbers


Set-Alias gs Git-NumberedStatus
Set-Alias ga Git-NumberedAdd
# Set-Alias gd Git-NumberedDiff
# Set-Alias grs Git-NumberedReset

# TODO: incorporate git diff --numstat?  +62/-15


function Git-NumberedStatus() {
	$global:gitStatusNumbers = git status -s | % {
		$file = $_.Substring(3)

		$returns = @()

		$staged = $_[0] -ne " " -and $_[0] -ne "?"
		if ($staged) {
			$returns + @{state=$_[0];file=$file;staged=$true}
		}

		$workingDir = $_[1] -ne " "
		if ($workingDir) {
			$state = If ($_[1] -eq "?") {"A"} Else {$_[1]}
			$returns += @{state=$state;file=$file;staged=$false}
		}
		return $returns

	} | % {$_}

	# $global:gitStatusNumbers

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


function Git-NumberedAdd {
	if (-not $global:gitStatusNumbers) {
		Write-Host "First run Git-NumberedStatus"
		return
	}
	if ($args.length -eq 0 -or $args[0] -eq $null) {
		Write-Host "No arguments? Usage:"
		Write-Host "Add the first file: 'Git-NumberedAdd 0'"
		Write-Host "Add the first 3 files: 'Git-NumberedAdd 0 1 2' or 'Git-NumberedAdd 0-2' or 'Git-NumberedAdd -3'"
		Write-Host "Add all files starting from 2: 'Git-NumberedAdd +1'"
		return
	}

	foreach ($arg in $args) {
		if ($arg -is [int]) {
			# Add by index
			$indexes = @($arg)

		} elseif ($arg -match '\d+-\d+') {
			# Add by range
			$begin = ($arg -split '-')[0]
			$end = ($arg -split '-')[1]
			$indexes = $begin..$end

		} elseif ($arg[0] -eq '-') {
			# Add all before
			$allBefore = $args.Substring(1) - 1
			$indexes = 0..$allBefore

		} elseif ($arg[0] -eq '+') {
			# Add all after
			$allAfter = $args.Substring(1) + 1
			$indexes = $allAfter..($global:gitStatusNumbers.length - 1)
		}

		foreach ($index in $indexes) {
			if ($index -ge $global:gitStatusNumbers.length) {
				Write-Host "$index is outside of the boundaries of Git-NumberedStatus (Length: $($global:gitStatusNumbers.length))"
				continue
			}
			$info = $global:gitStatusNumbers[$index]
			git add $info.file -v
		}
	}
}
