$config = Get-Content "$PSScriptRoot\links.json" | Out-String | ConvertFrom-Json

function Set-VariablePaths($path) {
	$path = $path.Replace('$HOME', $HOME)
	$path = $path.Replace('$PSScriptRoot', $PSScriptRoot)
	$path = $path.Replace('$MYDOCUMENTS', [Environment]::GetFolderPath("mydocuments"))
	$path = $path.Replace('$APPDATA_ROAMING', [Environment]::GetFolderPath("ApplicationData"))
	return $path
}

function Create-Link($data) {
	$link = Set-VariablePaths($data.link)
	$to = Set-VariablePaths($data.to)

	if ($data.type -eq "file") {
		$operation = "mklink $to $link"
	} else {
		$operation = "mklink /J $to $link"
	}

	if (-not (Test-Path ($to))) {
		cmd /c $operation

	} else {
		Write-Host "Already exists: $to" -ForegroundColor darkgray
	}
}

########################################################################## JUNCTIONS, SYMLINKS

Write-Title("JUNCTIONS")

for ($i = 0; $i -lt $config.links.length; $i++) {
	Create-Link $config.links[$i]
}

Write-Host

##################################################################### SHORTCUTS

$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\"

Write-Title("START WITH WINDOWS")
Write-Host "Programs starting when Windows starts"
Write-Host "Dir: $startupFolder" -ForegroundColor darkgray

for ($i = 0; $i -lt $config.autoStart.length; $i++) {
	$file = $config.autoStart[$i]
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
		Write-Host "Already autostarts: $file" -ForegroundColor darkgray
	}
}

Write-Host