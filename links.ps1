$links = Get-Content "links.json" | Out-String | ConvertFrom-Json

########################################################################## SYMLINKS

Write-Title("USERS FOLDER (HOME)")
Write-Host "Create symlinks for Users\Account"
Write-Host "Home: $HOME"

function Create-UserHomeLink($file) {
	$destination = "$HOME\$file"
	if (-not (Test-Path ($destination))) {
		$params = "mklink $destination $PSScriptRoot\Links\$file"
		cmd /c $params
	}
	else {
		Write-Host "Destination already existed: $file" -ForegroundColor red
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
	}
	else {
		Write-Host "Destination already existed: $link" -ForegroundColor red
	}
}

Write-Host