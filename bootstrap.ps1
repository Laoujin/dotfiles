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
#Process-Modules $config.modules

if ($config.shells) {
	Write-Title "SHELLS"
	$shellConfig = ConvertFrom-JsonFile "shells.json"
	Process-Modules $shellConfig.modules
	#Process-Program $shellConfig.bash
	#Process-Program $shellConfig.powershell
}

# Process-Programs $config.cinst


# $explorerOptions = Get-JsonObjectKeys $config.windows.explorer.registry
# foreach ($explorerOption in $explorerOptions) {
# 	$explorerConfig = $windowsConfig.explorer.registry.$explorerOption
# 	$explorerValue = $config.windows.explorer.registry.$explorerOption

# 	if (-not $explorerConfig) {
# 		Write-Error "No configuration found for $explorerOption"
# 	} else {

# 		$explorerConfig | Add-Member "value" $explorerValue
# 		Update-RegistryKey $explorerConfig | Write-Background
# 	}
# }


# TODO: check installed software instead of chocolatey...

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



# Next steps: 

# New context menu
# HKEY_CLASSES_ROOT -> find extension and delete ShellNew key
# To add: Add ShellNew key and add New String Value "NullFile" (with no value)

# Remove context menu items
#HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers

# many configurations can be found at:
#http://www.eightforums.com/tutorials/

# Useful Windows dotfiles?
# https://github.com/jayharris/dotfiles-windows/blob/master/windows.ps1 (IIS configuration etc)
## Explorer: Show hidden files by default (1: Show Files, 2: Hide Files)
# Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1

# # Explorer: show file extensions by default (0: Show Extensions, 1: Hide Extensions)
# Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0

# # Explorer: show path in title bar
# Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "FullPath" 1

# # Explorer: Avoid creating Thumbs.db files on network volumes
# Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "DisableThumbnailsOnNetworkFolders" 1

# # Taskbar: use small icons (0: Large Icons, 1: Small Icons)
# Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarSmallIcons" 1

# # Taskbar: Don't show Windows Store Apps on Taskbar
# Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "StoreAppsOnTaskbar" 0

# # SysTray: hide the Action Center, Network, and Volume icons
# Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "HideSCAHealth" 1
# Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "HideSCANetwork" 1
# Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "HideSCAVolume" 1
# #Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "HideSCAPower" 1

# # Recycle Bin: Disable Delete Confirmation Dialog
# Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "ConfirmFileDelete" 0

Pop-Location



# function Update-RegistryKey($desc, $hive, $regPathRaw, $regKey, $disabledValue, $activeValue) {

# OneDrive
#Peek-RegistryKey "HKEY_CLASSES_ROOT" "CLSID\{8E74D236-7F35-4720-B138-1FED0B85EA75}\ShellFolder"

#Update-RegistryKey "OneDrive icon in Navigation pane" 'HKEY_CLASSES_ROOT' 'CLSID\{8E74D236-7F35-4720-B138-1FED0B85EA75}\ShellFolder' "Attributes" 4034920525 4035969101

# LEFT OF Here #
################
# - Update-RegistryKey should work. Peek-RegistryKey: Not tested (and missing parameter)
# - registry.json contains regKeys for one but it is not yet read.

# Homegroup
# services.msc
# Stop HomeGroup Listener and HomeGroup Provider
# Control Panel -> Advanced Sharing Settings -> Turn off network discovery

# Network
#Update-RegistryKey "Network icon in Navigation pane" 'HKEY_CLASSES_ROOT' 'CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder' "Attributes" 2953052260 2962489444

# This PC Folders
# This is done in registry.ps1

#Update-RegistryKey "User folder group in Windows Explorer" 'HKEY_CURRENT_USER' 'Software\Classes\CLSID\{59031a47-3f72-44a7-89c5-5595fe6b30ee}' "System.IsPinnedToNameSpaceTree" 00000001 00000000


# Library
# currently not visible in open/close dialog


# open/save dialogs (Windows 8.1)
#Update-RegistryKey "OneDrive in open/save dialogs" 'HKEY_LOCAL_MACHINE' 'SOFTWARE\Wow6432Node\Classes\CLSID\{8E74D236-7F35-4720-B138-1FED0B85EA75}\ShellFolder' "Attributes" 4034920525 4035969101
#Update-RegistryKey "Network in open/save dialogs" 'HKEY_LOCAL_MACHINE' 'SOFTWARE\Wow6432Node\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder' "Attributes" 2953052260 2962489444



		# "fiddler4",
		# "google-chrome-x64",
		# "firefox",
		# "opera",
		# "git",
		# "git-credential-winstore",
		# "sublimetext3",
		# "sublimetext3.packagecontrol",
		# "notepadplusplus.install",
		# "dropbox",
		# "onedrive",
		# "googledrive",
		# "cmder",
		# "sysinternals",
		# "procexp",
		# "beyondcompare3",
		# "diffmerge",
		# "heidisql",
		# "ultramon -version 3.3.0",
		# "wamp-server",
		# "autohotkey",
		# "powershell",
		# "powergui",
		# "nodejs.install",
		# "python2",
		# "python",
		# "virtualbox",
		# "vagrant",
		# "sourcetree",
		# "teamviewer",
		# "vlc",
		# "utorrent",
		# "skype",
		# "7zip.install",
		# "filezilla",
		# "irfanview",
		# "paint.net",
		# "greenshot",
		# "sumatrapdf",
		# "ditto",
		# "teracopy",
		# "markdownpad2",
		# "windowslivewriter",
		# "libreoffice",
		# "dotnet4.5.1",
		# "linqpad4",
		# "ilspy",
		# "dotpeek",
		# "visualstudiocommunity2013"