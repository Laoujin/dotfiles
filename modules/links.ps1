function Install-ChocolateyPackage() {
	if (-not (Check-Command "cinst")) {
		Write-Output "Installing Chocolatey"
		iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
	}
}

function Replace-VariablePaths($path) {
	$path = $path.Replace('$HOME', $HOME)
	$path = $path.Replace('$PSScriptRoot', $PSScriptRoot)
	$path = $path.Replace('$MYDOCUMENTS', [Environment]::GetFolderPath("mydocuments"))
	$path = $path.Replace('$APPDATA_ROAMING', [Environment]::GetFolderPath("ApplicationData"))
	return $path
}

function Get-InstalledSoftware {
	Install-ChocolateyPackage

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
	foreach ($link in $links) {
		Create-Link $link
	}
}

##################################################################### STARTUP

function Create-Shortcut($file, $targetPath) {
	$fileName = [System.IO.Path]::GetFileName($file)
	$link = Join-Path $targetPath "$fileName.lnk"

	if (-not (Test-Path ($link))) {
		$WshShell = New-Object -comObject WScript.Shell
		$Shortcut = $WshShell.CreateShortcut($link)
		$Shortcut.TargetPath = $file
		$Shortcut.WorkingDirectory = Split-Path $file
		$Shortcut.Save()
		Write-Output "Link created: $file"

	} else {
		Write-Output "Already autostarts: $file"
	}
}