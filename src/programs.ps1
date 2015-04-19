function Install-ChocolateyPackage() {
	if (-not (Check-Command "cinst")) {
		Write-Output "Installing Chocolatey"
		iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
		$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
	}
}

function Get-InstalledPrograms {
	Install-ChocolateyPackage

	if ($script:installedSoftware -eq $null) {
		$script:installedSoftware = & choco list -localonly
	}
	return $script:installedSoftware
}

function Check-Installed($program) {
	$installed = Get-InstalledPrograms
	return $installed -match "^$program"
}