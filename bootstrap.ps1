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

Write-Title "BOOTSTRAP"
Process-Modules $config.modules

if ($config.shells) {
	Write-Title "SHELLS"
	$shellConfig = ConvertFrom-JsonFile "shells.json"
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

# Desired State configuration
# https://gallery.technet.microsoft.com/scriptcenter/DSC-Resource-Kit-All-c449312d

# Interesting:
# https://gallery.technet.microsoft.com/scriptcenter/Get-RemoteProgram-Get-list-de9fd2b4

# File System Security PowerShell Module
# https://gallery.technet.microsoft.com/scriptcenter/1abd77a5-9c0b-4a2b-acef-90dbb2b84e85

# git alias: clone and enter dir
# ps: cd..... -> also in bash
# autohotkey: open and set most often used folder / open in explorer / in cmder new tab?
#(http://www.techunboxed.com/2013/09/how-to-disable-aero-shake-in-windows-8.html)
#~/.bash_aliases

# Library
# Install-Package WindowsAPICodePack-Core
# Install-Package WindowsAPICodePack-Shell
# Microsoft.WindowsAPICodePack.Shell.KnownFolders.Libraries
# http://blogs.technet.com/b/heyscriptingguy/archive/2012/11/11/weekend-scripter-working-with-windows-libraries.aspx

Stop-Process -processname explorer

# SETTINGS TO ADD
# fileZilla, notepadplusplus.install, SublimeText3, ultramon, beyondcompare3 ...
# resharper, visual studio
# software not installed through chocolatey: webstorm, fences

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
# "showHomeGroupIconInWindowsExplorer":
# {
# 	"type": "toggle",
# 	"context": "explorer",
# 	"desc": "",
# 	"hive": "HKEY_LOCAL_MACHINE",
# 	"regPathRaw": "SOFWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Desktop\\NameSpace\\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}",
# }
# --> Delete key to remove the Homegroup icon in Windows Explorer.
# --> But didn't save it to see how to put it back :p