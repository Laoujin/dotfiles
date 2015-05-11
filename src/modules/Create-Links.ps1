function Create-Links($links) {
	foreach ($link in $links) {
		Create-Link $link
	}
}

function Replace-VariablePaths($path) {
	$path = $path.Replace('<HOME>', $HOME)
	#$path = $path.Replace('<PSScriptRoot>', $PSScriptRoot)
	$path = $path.Replace('<MYDOCUMENTS>', [Environment]::GetFolderPath("mydocuments"))
	$path = $path.Replace('<APPDATA_ROAMING>', [Environment]::GetFolderPath("ApplicationData"))

	return $path
}

function Create-Link($data) {
	$link = Replace-VariablePaths($data.link)
	if (-not [System.IO.Path]::IsPathRooted($link)) {
		$link = Join-Path (Get-Location) $link
	}
	$to = Replace-VariablePaths($data.to)

	if ($data.type -eq "symlink") {
		$operation = "mklink $to $link"

	} elseif ($data.type -eq "junction") {
		$operation = "mklink /J $to $link"
	}

	if ($data.requires -and -not (Check-Installed $data.requires)) {
		Write-Output "Skipping $($data.requires) files"
		return
	}

	if (-not (Test-Path $link)) {
		Write-Verbose "DOES NOT EXIST: $link" -Verbose
		return
	}

	if (-not (Test-Path $to)) {
		cmd /c $operation

	} else {
		Write-Output "Symlink already exists: $to"
	}
}