Write-Title("USERS FOLDER (HOME)")
Write-Host "Create symlinks for Users\Account"
Write-Host "Home: $HOME"

$links = Get-Content "links.json" | Out-String | ConvertFrom-Json

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