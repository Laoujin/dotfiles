$global:gitStatusNumbers


Set-Alias gs Git-NumberedStatus
Set-Alias ga Git-NumberedAdd
Set-Alias gd Git-NumberedDiff
Set-Alias grs Git-NumberedReset

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


function Validate-GitIndexes($indexes) {
	if (-not $global:gitStatusNumbers) {
		Write-Host "First run Git-NumberedStatus"
		return $false
	}

	if ($indexes.length -eq 0 -or $indexes[0] -eq $null) {
		Write-Host "No arguments? Usage:"
		Write-Host "Add the first file: 'Git-NumberedAdd 0'"
		Write-Host "Add the first 3 files: 'Git-NumberedAdd 0 1 2' or 'Git-NumberedAdd 0-2' or 'Git-NumberedAdd -3'"
		Write-Host "Add all files starting from 2: 'Git-NumberedAdd +1'"
		return $false
	}

	return $true
}


function Parse-GitIndexes($argIndexes) {
	if (-not (Validate-GitIndexes $argIndexes)) {
		return
	}

	$indexes = @()
	foreach ($arg in $argIndexes) {
		if ($arg -is [int]) {
			# Add by index
			$indexes += $arg

		} elseif ($arg -match '\d+-\d+') {
			# Add by range
			$begin = ($arg -split '-')[0]
			$end = ($arg -split '-')[1]
			$indexes += $begin..$end

		} elseif ($arg[0] -eq '-') {
			# Add all before
			$allBefore = $arg.Substring(1) - 1
			$indexes += 0..$allBefore

		} elseif ($arg[0] -eq '+') {
			# Add all after
			$allAfter = $arg.Substring(1) + 1
			$indexes += $allAfter..($global:gitStatusNumbers.length - 1)
		} else {
			Write-Host "Unparseable argument '$arg'" -ForegroundColor DarkMagenta
		}
	}

	return $indexes | % {$_} | ? {
		if ($_ -ge $global:gitStatusNumbers.length) {
			Write-Host "$_ is outside of the boundaries of Git-NumberedStatus (Length: $($global:gitStatusNumbers.length))"
			return $false
		}
		return $true
	} | % { $global:gitStatusNumbers[$_] }
}



function Git-NumberedAdd {
	$fileInfos = Parse-GitIndexes $args
	if (-not $fileInfos) {
		return
	}

	foreach ($info in $fileInfos) {
		git add $info.file -v
	}
}


function Git-NumberedDiff {
	$fileInfos = Parse-GitIndexes $args
	if (-not $fileInfos) {
		return
	}

	# TODO: git diff added file --> git add -N ?
	# TODO: should call once instead of looping...
	foreach ($info in $fileInfos) {
		if ($info.state -eq 'A') {
			git add -N $info.file
		}
		git diff $info.file
	}
}


function Git-NumberedReset {
$fileInfos = Parse-GitIndexes $args
	if (-not $fileInfos) {
		return
	}

	# TODO: Cannot reset already staged files now...
	# Negative indexes for diffing --cached?

	# git reset HEAD -- $info.file

	foreach ($info in $fileInfos) {
		git reset HEAD -- $info.file
	}
}
