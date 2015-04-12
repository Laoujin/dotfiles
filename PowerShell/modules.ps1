if (-not (Get-Command 'Install-Module' -errorAction SilentlyContinue))
{
	(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
	. $PROFILE
}

Install-Module posh-git
