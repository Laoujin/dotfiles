$global:gitStatusNumbers


Set-Alias gs Git-NumberedStatus
Set-Alias ga Git-NumberedAdd


# TODO: write article about usage (with some pretty pictures:)

function Git-NumberedStatus() {
	$global:gitStatusNumbers = git status -s | % {
		$file = $_.Substring(3)

		$staged = $_[1] -eq " "
		$state = If ($staged) {$_[0]} Else {$_[1]}
		$state = If ($state -eq "?") {"A"} Else {$state}
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
