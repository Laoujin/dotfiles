﻿$links = Get-Content "links.json" | Out-String | ConvertFrom-Json

########################################################################## SYMLINKS

Write-Title("USERS FOLDER (HOME)")
Write-Host "Create symlinks for Users\Account"
Write-Host "Home: $HOME"

function Create-UserHomeLink($file) {
	$destination = "$HOME\$file"
	if (-not (Test-Path ($destination))) {
		$params = "mklink $destination $PSScriptRoot\Links\$file"
		cmd /c $params

	} else {
		Write-Host "Destination already existed: $file" -ForegroundColor darkgray
	}
}

for ($i = 0; $i -lt $links.home.length; $i++) {
	Create-UserHomeLink $links.home[$i]
}

Write-Host

########################################################################## JUNCTIONS

Write-Title("JUNCTIONS")

for ($i = 0; $i -lt $links.dirs.length; $i++) {
	$link = $links.dirs[$i].link
	$target = $links.dirs[$i].target.Replace('$HOME', $HOME)
	
	if (-not (Test-Path ($link))) {
		$params = "mklink /J $link $target"
		cmd /c $params

	} else {
		Write-Host "Destination already existed: $link" -ForegroundColor darkgray
	}
}

Write-Host

##################################################################### SHORTCUTS

$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\"

Write-Title("START WITH WINDOWS")
Write-Host "Programs starting when Windows starts"
Write-Host "Dir: $startupFolder"

for ($i = 0; $i -lt $links.autoStart.length; $i++) {
	$file = $links.autoStart[$i]
	$fileName = [System.IO.Path]::GetFileName($file)
	$link = "$startupFolder$fileName.lnk"

	if (-not (Test-Path ($link))) {
		$WshShell = New-Object -comObject WScript.Shell
		$Shortcut = $WshShell.CreateShortcut($link)
		$Shortcut.TargetPath = $file
		$Shortcut.WorkingDirectory = Split-Path $file
		$Shortcut.Save()
		Write-Host "Link created: $file" -ForegroundColor yellow

	} else {
		Write-Host "Autostarts already: $file" -ForegroundColor darkgray
	}
}

Write-Host