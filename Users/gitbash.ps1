################
"## GIT BASH ##"
################
function createUserHomeLink($file)
{
	$destination = "$HOME\$file"
	if (-not (Test-Path ($destination)))
	{
		$params = "mklink $destination $PSScriptRoot\$file"
		cmd /c $params
	}
}

createUserHomeLink ".gitconfig"
createUserHomeLink ".bashrc"