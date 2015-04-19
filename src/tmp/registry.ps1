for ($i = 0; $i -lt $config.regFiles.length; $i++) {
	$reg = $config.regFiles[$i]
	$color = if ($reg.value -eq $reg.default) {"white"} else {"darkmagenta"}

	Write-Host "$($reg.desc): " -nonewline -ForegroundColor $color
	if ($reg.value -eq "on") {
		Write-Host "On" -ForegroundColor $color
		$regFile = "$PSScriptRoot\$($reg.fileOn)"

	} else {
		Write-Host "Off" -ForegroundColor $color
		$regFile = "$PSScriptRoot\$($reg.fileOff)"
	}
	& regedit /s $regFile
}

# rest of the registry stuff is done in explorer.ps1

# registry.json structure:
# {
#    "context": "Windows Explorer",
#    "desc": "On: Show the Desktop, Documents, Downloads, Music, Pictures and Videos folders below 'This PC'",
#    "fileOn": "Explorer_ThisPCFolders_Restore.reg",
#    "fileOff": "Explorer_ThisPCFolders_Remove.reg",
#    "default": "on",
#    "value": "off"
# }

Write-Host