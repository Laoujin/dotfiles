cls

#Set-ExecutionPolicy Unrestricted

Push-Location "$PSScriptRoot\modules"
. ".\Helpers\Console.ps1"
. ".\helpers.ps1"
. ".\links.ps1"
. ".\PowerShell-Modules.ps1"
Pop-Location

Write-Title "Configure You Windows" $false
Write-Host "Because registry editing is so much fun"
Write-Host "Boxstarter Url: https://gist.github.com/Laoujin/12f5d2f76d51ee6c0a49"

$config = ConvertFrom-JsonFile ".\bootstrap.json"

Push-Location "$PSScriptRoot\config"

# Write-Title "BOOTSTRAP"
# Process-Modules $config.modules

# if ($config.shells) {
# 	$shellConfig = ConvertFrom-JsonFile "shells.json"
# 	Process-Program $shellConfig.bash
# 	Process-Program $shellConfig.powershell
# }

Process-Programs $config.cinst



#alias d="cd ~/Dropbox"
#read from json and also create the aliases for powershell
#echo aliases: sangu, tactics, autokey, code, www, dotfiles

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