function Install-NodePackages($packages) {
	foreach ($package in $packages) {
		Update-NodePackage $package
	}
}

function Get-InstalledNodePackages {
	if ($script:installedNodePackages -eq $null) {
		$script:installedNodePackages = (& npm list -g --depth=0) | Out-String
	}
	return $script:installedNodePackages
}

function Update-NodePackage($name) {
	$installed = Get-InstalledNodePackages
	if ($installed -like "*$name@*") {
		Write-Output "Updating $name"
		npm update -g $name
	} else {
		Write-Output "Installing $name"
		npm install -g $name
	}
}