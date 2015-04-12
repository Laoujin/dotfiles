Write-Title("USERS FOLDER (HOME)")
Write-Host "Create symlinks for Users\Account"
Write-Host "Home: $HOME"

function createUserHomeLink($file) {
	$destination = "$HOME\$file"
	if (-not (Test-Path ($destination))) {
		$params = "mklink $destination $PSScriptRoot\$file"
		cmd /c $params
	}
	else {
		Write-Host "Destination already existed: $file" -ForegroundColor red
	}
}

createUserHomeLink ".gitconfig"
createUserHomeLink ".bashrc"