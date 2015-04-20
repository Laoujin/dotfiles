cls

#Set-ExecutionPolicy Unrestricted

Push-Location "$PSScriptRoot\src"
. ".\bootstrap-functions.ps1"
. ".\helpers.ps1"
. ".\programs.ps1"
Pop-Location

Push-Location "$PSScriptRoot\src\modules"
Get-ChildItem | ForEach-Object { . ".\$_" }
Pop-Location

Push-Location "$PSScriptRoot\src\lib"
Get-ChildItem | ForEach-Object { . ".\$_" }
Pop-Location

Write-Title "Configure You Windows" $false
Write-Host "Because registry editing is so much fun"
Write-Host "Boxstarter Url: https://gist.github.com/Laoujin/12f5d2f76d51ee6c0a49"

$config = ConvertFrom-JsonFile ".\bootstrap.json"
$windowsConfig = ConvertFrom-JsonFile ".\src\windows.json"

Push-Location "$PSScriptRoot\config"

# Write-Title "BOOTSTRAP"
# Process-Modules $config.modules

# if ($config.shells) {
# 	Write-Title "SHELLS"
# 	$shellConfig = ConvertFrom-JsonFile "shells.json"
# 	Process-Modules $shellConfig.modules
# 	Process-Program $shellConfig.bash
# 	Process-Program $shellConfig.powershell
# }

# Process-Programs $config.cinst


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

Stop-Process -processname explorer

# function Update-RegistryKey($desc, $hive, $regPathRaw, $regKey, $disabledValue, $activeValue) {
# Network


#Update-RegistryKey "User folder group in Windows Explorer" 'HKEY_CURRENT_USER' 'Software\Classes\CLSID\{59031a47-3f72-44a7-89c5-5595fe6b30ee}' "System.IsPinnedToNameSpaceTree" 00000001 00000000



# SETTINGS TO ADD
# fileZilla, MarkdownPad2, notepadplusplus.install, SublimeText3, ultramon, utorrent, beyondcompare3 ...
# resharper, visual studio
# software not installed through chocolatey: webstorm, fences

# Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions


# aspnetmvc.install # not updated to MVC5!!!",
# sqlserver2012express",
# mssqlservermanagementstudio2014express ",
# popcorntime",
# subtitleedit",
# webstorm6 # NEEDS MANUAL INSTALL",
# zoomit",
# dexpot",


# New context menu
# HKEY_CLASSES_ROOT -> find extension and delete ShellNew key
# To add: Add ShellNew key and add New String Value "NullFile" (with no value)

# Remove context menu items
#HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers

# many configurations can be found at:
#http://www.eightforums.com/tutorials/

# Useful Windows dotfiles?
# https://github.com/jayharris/dotfiles-windows/blob/master/windows.ps1 (IIS configuration etc)

Pop-Location





# Homegroup
# services.msc
# Stop HomeGroup Listener and HomeGroup Provider
# Control Panel -> Advanced Sharing Settings -> Turn off network discovery

# Library
# currently not visible in open/close dialog