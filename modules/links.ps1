function Install-ChocolateyPackage() {

}

function Replace-VariablePaths($path) {
	$path = $path.Replace('$HOME', $HOME)
	$path = $path.Replace('$PSScriptRoot', $PSScriptRoot)
	$path = $path.Replace('$MYDOCUMENTS', [Environment]::GetFolderPath("mydocuments"))
	$path = $path.Replace('$APPDATA_ROAMING', [Environment]::GetFolderPath("ApplicationData"))
	return $path
}

function Get-InstalledSoftware {
	if ($script:installedSoftware -eq $null) {
		$script:installedSoftware = & choco list -localonly
	}
	return $script:installedSoftware
}

##################################################################### LINKS

function Check-Installed($program) {
	$installed = Get-InstalledSoftware
	return $installed -match "^$program"
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

	if (-not (Test-Path $to)) {
		cmd /c $operation

	} else {
		Write-Output "Already exists: $to"
	}
}

function Create-Links($links) {
	for ($i = 0; $i -lt $links.length; $i++) {
		Create-Link $links[$i]
	}
}

##################################################################### SHORTCUTS

# $startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\"

# Write-Title("START WITH WINDOWS")
# Write-Host "Programs starting when Windows starts"
# Write-Host "Dir: $startupFolder" -ForegroundColor darkgray

# for ($i = 0; $i -lt $config.autoStart.length; $i++) {
# 	$file = $config.autoStart[$i]
# 	$fileName = [System.IO.Path]::GetFileName($file)
# 	$link = "$startupFolder$fileName.lnk"

# 	if (-not (Test-Path ($link))) {
# 		$WshShell = New-Object -comObject WScript.Shell
# 		$Shortcut = $WshShell.CreateShortcut($link)
# 		$Shortcut.TargetPath = $file
# 		$Shortcut.WorkingDirectory = Split-Path $file
# 		$Shortcut.Save()
# 		Write-Host "Link created: $file" -ForegroundColor yellow

# 	} else {
# 		Write-Host "Already autostarts: $file" -ForegroundColor darkgray
# 	}
# }

# Write-Host