# New context menu
# HKEY_CLASSES_ROOT -> find extension and delete ShellNew key
# To add: Add ShellNew key and add New String Value "NullFile" (with no value)

# Remove context menu items
#HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers

net user Administrator /active:yes

To automatically login:
netplwiz


# Homegroup
# services.msc
# Stop HomeGroup Listener and HomeGroup Provider
# Control Panel -> Advanced Sharing Settings -> Turn off network discovery
# "showHomeGroupIconInWindowsExplorer":
# {
#   "type": "toggle",
#   "context": "explorer",
#   "desc": "",
#   "hive": "HKEY_LOCAL_MACHINE",
#   "regPathRaw": "SOFWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Desktop\\NameSpace\\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}",
# }
# --> Delete key to remove the Homegroup icon in Windows Explorer.
# --> But didn't save it to see how to put it back :p


# Download stuff:
# https://github.com/chaliy/psurl/

# PSCX source: (download source, has some interesting functions)
# http://pscx.codeplex.com/
# See also: C:\Program Files (x86)\PowerShell Community Extensions\Pscx3\Pscx

---------------------------------------------------------------------------------------

# Interesting:
# https://gallery.technet.microsoft.com/scriptcenter/Get-RemoteProgram-Get-list-de9fd2b4

# File System Security PowerShell Module
# https://gallery.technet.microsoft.com/scriptcenter/1abd77a5-9c0b-4a2b-acef-90dbb2b84e85

# Library
# Install-Package WindowsAPICodePack-Core
# Install-Package WindowsAPICodePack-Shell
# Microsoft.WindowsAPICodePack.Shell.KnownFolders.Libraries
# http://blogs.technet.com/b/heyscriptingguy/archive/2012/11/11/weekend-scripter-working-with-windows-libraries.aspx

---------------------------------------------------------------------------------------

# Make vim the default editor
Set-Environment "EDITOR" "vim" # would this actually overwrite notepad?
Set-Environment "GIT_EDITOR" $Env:EDITOR


# HKUsers drive for Registry
if ((Get-PSDrive HKUsers -ErrorAction SilentlyContinue) -eq $null) { New-PSDrive -Name HKUSERS -PSProvider Registry -Root Registry::HKEY_USERS | Out-Null }

