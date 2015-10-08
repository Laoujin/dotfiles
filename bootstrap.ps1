#Set-ExecutionPolicy Unrestricted

Push-Location "$PSScriptRoot\src"
. ".\bootstrap-functions.ps1"
. ".\helpers.ps1"
. ".\programs.ps1"
Pop-Location

if (!(Is-Admin)) {
	Write-Host "RunAs Administrator..."
	Exit
}

Clear-Host

Push-Location "$PSScriptRoot\src\modules"
Get-ChildItem | ForEach-Object { . ".\$_" }
Pop-Location

Push-Location "$PSScriptRoot\src\lib"
Get-ChildItem | ForEach-Object { . ".\$_" }
Pop-Location

Write-Title "Configure You Windows" $false
Write-Host "Because registry editing is so much fun"
Write-Host "Boxstarter Url: https://gist.github.com/Laoujin/12f5d2f76d51ee6c0a49"

$config = Combine-Configs ".\bootstrap.json" ".\bootstrap-domain.json"
$windowsConfig = ConvertFrom-JsonFile ".\src\windows.json"

Push-Location "$PSScriptRoot\config"

Write-Title "BOOTSTRAP"
Process-Modules $config.modules

if ($config.shells) {
	Write-Title "SHELLS"
	$shellConfig = Combine-Configs "shells.json" "shells-domain.json"
	Process-Modules $shellConfig.modules
	Process-Program $shellConfig.bash
	Process-Program $shellConfig.powershell
}

Write-Title "PROGRAMS"
Process-Programs $config.cinst


Write-Title "WINDOWS EXPLORER"
$explorerOptions = Get-JsonObjectKeys $config.windows.explorer.registry
foreach ($explorerOption in $explorerOptions) {
	$explorerConfig = $windowsConfig.explorer.registry.$explorerOption
	$explorerValue = $config.windows.explorer.registry.$explorerOption

	if (-not $explorerConfig) {
		Write-Error "No configuration found for $explorerOption"
	} else {

		$explorerConfig | Add-Member "value" $explorerValue
		Update-RegistryKey $explorerConfig | Write-Background
	}
}

#Stop-Process -processname explorer

Pop-Location