function Install-PS-ModulesGetter {
	if (-not (Check-Command 'Install-Module'))
	{
		Write-Output "Installing PsGet"
		(New-Object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
		. $PROFILE
	}
}

function Install-PS-Modules($modules) {
	if ($modules -contains "PsGet") {
		Install-PS-ModulesGetter
	}

	foreach ($module in $modules) {
		if ($module -ne "PsGet") {
			Write-Output "Installing PS Module $module"
			Install-Module $module -Force
		}
	}
}
