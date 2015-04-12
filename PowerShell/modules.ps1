Write-Title("POWERSHELL")

if (-not (Get-Command 'Install-Module' -errorAction SilentlyContinue))
{
	(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
	. $PROFILE
}

Write-Host "Installing PS Modules"
Install-Module posh-git

Write-Host