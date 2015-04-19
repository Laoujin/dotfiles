function Create-StartupLinks($files) {
	$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\"

	Write-Title "START WITH WINDOWS"
	Write-Output "Programs starting when Windows starts" | Write-Background
	Write-Output "Dir: $startupFolder" | Write-Background

	foreach ($file in $files) {
		Create-Shortcut $file $startupFolder
	}
}

function Create-Shortcut($file, $targetPath) {
	$fileName = [System.IO.Path]::GetFileName($file)
	$link = Join-Path $targetPath "$fileName.lnk"

	if (-not (Test-Path ($link))) {
		$WshShell = New-Object -comObject WScript.Shell
		$Shortcut = $WshShell.CreateShortcut($link)
		$Shortcut.TargetPath = $file
		$Shortcut.WorkingDirectory = Split-Path $file
		$Shortcut.Save()
		Write-Output "Shortcut created: $file"

	} else {
		Write-Output "Shortcut already exists: $file"
	}
}