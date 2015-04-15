cls

#Set-ExecutionPolicy Unrestricted

. .\Helpers\Console.ps1
#Show-Colors # defined in Helpers\Console.ps1

Write-Title("Boxstarter")
Write-Host "Install all software with Boxstarter"
Write-Host "Url: https://gist.github.com/Laoujin/12f5d2f76d51ee6c0a49"
Write-Host

& "$PSScriptRoot\links.ps1"

#& "$PSScriptRoot\PowerShell\modules.ps1"

#& "$PSScriptRoot\shell\node-npm.ps1"

#& "$PSScriptRoot\Settings\explorer.ps1"
#& "$PSScriptRoot\Settings\registry.ps1"

# SETTINGS TO ADD
# fileZilla, MarkdownPad2, notepadplusplus.install, SublimeText3, ultramon, utorrent, beyondcompare3 ...
# resharper, visual studio
# software not installed through chocolatey: webstorm, fences


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

