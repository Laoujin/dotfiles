#Set-ExecutionPolicy Unrestricted

if (!(Is-Admin)) {
	Write-Host "RunAs Administrator..."
	Exit
}


# Load scripts
Push-Location "$PSScriptRoot\src"
. ".\bootstrap-functions.ps1"
. ".\helpers.ps1"
. ".\programs.ps1"
Pop-Location

Push-Location "$PSScriptRoot\src\modules"
Get-ChildItem | ForEach-Object { . ".\$_" }
Pop-Location

Push-Location "$PSScriptRoot\src\lib"
Get-ChildItem -Filter *.ps1 | ForEach-Object { . ".\$_" }
Pop-Location

Import-Module "$PSScriptRoot\src\lib\PSYaml"



Clear-Host
Write-Title "Configure You Windows" $false
Write-Host "Because registry editing is so much fun"
Write-Host "Boxstarter Url: https://gist.github.com/Laoujin/12f5d2f76d51ee6c0a49"


Push-Location "$PSScriptRoot\config\"


# Start bootstrapping
Write-Title "BOOTSTRAP"
Get-Childitem "$PSScriptRoot\bootstrap" -Filter *.yml -Recurse | Foreach-Object {
	Write-Title $_.BaseName.ToUpper()
	$_.FullName
	$conf = ConvertFrom-Yaml -Path $_.FullName
	Process-Modules $conf $true
}



Write-Title "PROGRAMS"
$chocoNames = Get-Content "$PSScriptRoot\config\chocolatey.txt"
Process-Programs $chocoNames



# TODO: Check DSC instead of this ...

Pop-Location
return




# Read configuration
$config = ConvertFrom-JsonFile "$PSScriptRoot\bootstrap.json"
# Content of file:
# {
# 	"windows":
# 	{
# 		"explorer":
# 		{
# 			"registry":
# 			{
# 				"showThisPCFolders": "hide",
# 				"showOneDrive": "hide",
# 				"showHiddenFilesFoldersDrives": "show",
# 				"showFileExtensions": "show",
# 				"showProtectedOSFiles": "show",
# 				"showFullPathInTitleBar": "show",
# 				"showNetworkIconInNavigationPane": "hide",
# 				"showLibrariesInWindowsExplorer": "show",
# 				"enableAeroWindowsShake": "disabled"
# 			}
# 		}
# 	}
# }



Write-Title "WINDOWS EXPLORER"
$windowsConfig = ConvertFrom-JsonFile "$PSScriptRoot\src\windows.json"
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



Pop-Location
