$config = Get-Content "$PSScriptRoot\links.json" | Out-String | ConvertFrom-Json

function Set-VariablePaths($path) {
	$path = $path.Replace('$HOME', $HOME)
	$path = $path.Replace('$PSScriptRoot', $PSScriptRoot)
	$path = $path.Replace('$MYDOCUMENTS', [environment]::getfolderpath("mydocuments"))
	return $path
}

########################################################################## JUNCTIONS

Write-Title("JUNCTIONS")

for ($i = 0; $i -lt $config.dirs.length; $i++) {
	$link = Set-VariablePaths($config.dirs[$i].link)
	$target = Set-VariablePaths($config.dirs[$i].to)
	
	if (-not (Test-Path ($link))) {
		$params = "mklink /J $link $target"
		cmd /c $params

	} else {
		Write-Host "Destination already existed: $link" -ForegroundColor darkgray
	}
}

Write-Host

########################################################################## SYMLINKS

Write-Title("SYMLINKS")

function Create-FileLink($file, $to) {
	$file = Set-VariablePaths($file)
	$to = Set-VariablePaths($to)

	if (-not (Test-Path ($to))) {
		$params = "mklink $to $file"
		cmd /c $params

	} else {
		Write-Host "Destination already existed: $to" -ForegroundColor darkgray
	}
}

for ($i = 0; $i -lt $config.files.length; $i++) {
	Create-FileLink $config.files[$i].link $config.files[$i].to
}

Write-Host

##################################################################### SHORTCUTS

$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\"

Write-Title("START WITH WINDOWS")
Write-Host "Programs starting when Windows starts"
Write-Host "Dir: $startupFolder"

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
		Write-Host "Autostarts already: $file" -ForegroundColor darkgray
	}
}

Write-Host