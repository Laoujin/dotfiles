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

$currentPath = Split-Path $MyInvocation.PSCommandPath
$config = Get-Content "$currentPath\shell\node-npm.json" | Out-String | ConvertFrom-Json

for ($i = 0; $i -lt $config.length; $i++) {
	Update-Node-Package $config[$i]
}

Write-Host