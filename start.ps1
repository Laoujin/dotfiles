cls

#Set-ExecutionPolicy Unrestricted

. .\Helpers\Console.ps1
#Show-Colors
#$Host.UI.RawUI.ForegroundColor = 

Write-Title("Boxstarter")
Write-Host "Install all software with Boxstarter"
Write-Host "Url: https://gist.github.com/Laoujin/12f5d2f76d51ee6c0a49"
Write-Host

& "$PSScriptRoot\links.ps1"

& "$PSScriptRoot\PowerShell\modules.ps1"

#& "$PSScriptRoot\shell\node-npm.ps1"

& "$PSScriptRoot\Settings\explorer.ps1"