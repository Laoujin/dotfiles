Write-Title("NODE")
Write-Host "Installing Global NPM Packages"

$installed = (& npm list -g --depth=0) | Out-String

function Update-Node-Package($name) {
	if ($installed -like "*$name@*") {
		npm update -g $name
	} else {
		npm install -g $name
	}
}

Update-Node-Package "gulp"
Update-Node-Package "jade"

Write-Host