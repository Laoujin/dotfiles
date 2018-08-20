function Write-Title($title, $addSpace = $true) {
	if ($addSpace) {
		Write-Host
	}

	$titleHeader = "#" * ($title.length + 6)
	Write-Host $titleHeader -ForegroundColor darkgreen
	Write-Host "## $title ##" -ForegroundColor darkgreen
	Write-Host $titleHeader -ForegroundColor darkgreen
}


function Write-Background {
	process {
		Write-Host $_ -ForegroundColor darkgray
	}
}
