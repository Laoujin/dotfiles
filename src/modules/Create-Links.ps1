function Create-Links($links) {
	foreach ($link in $links) {
		if ($data.requires -and -not (Check-Installed $data.requires)) {
			Write-Output "Skipping $($data.requires) files"
			continue
		}
	
		if ($link.match) {
			Create-Symlinks $link
		} else {
			Create-Symlink $link.link $link.to $link.type
		}
	}
}

function Replace-VariablePaths($path) {
	$path = $path.Replace('<HOME>', $HOME)
	#$path = $path.Replace('<PSScriptRoot>', $PSScriptRoot)
	$path = $path.Replace('<MYDOCUMENTS>', [Environment]::GetFolderPath("mydocuments"))
	$path = $path.Replace('<APPDATA_ROAMING>', [Environment]::GetFolderPath("ApplicationData"))

	if (-not [System.IO.Path]::IsPathRooted($path)) {
		$path = Join-Path (Get-Location) $path
	}
	
	return $path
}

function Create-Symlinks($data) {
	$link = Replace-VariablePaths($data.link)
	
	$files = Get-ChildItem $link -Filter $data.match
	foreach ($file in $files) {
		Create-Symlink $file.FullName (Join-Path $data.to $file.Name) $data.type
	}
}

function Create-Symlink($link, $to, $type) {
	$link = Replace-VariablePaths($link)
	$to = Replace-VariablePaths($to)
	
	if ($type -eq "symlink") {
		$operation = "mklink `"$to`" `"$link`""
 
	} elseif ($type -eq "junction") {
		$operation = "mklink /J `"$to`" `"$link`""
		
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