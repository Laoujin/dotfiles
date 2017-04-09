# New context menu
# HKEY_CLASSES_ROOT -> find extension and delete ShellNew key
# To add: Add ShellNew key and add New String Value "NullFile" (with no value)

# Remove context menu items
#HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers

download "Everything": https://en.wikipedia.org/wiki/Everything_(software)
https://github.com/denolfe/AutoHotkey/blob/master/AppSpecific/WindowsExplorer.ahk

net user Administrator /active:yes

To automatically login:
netplwiz


Mi-Ke: quick editor for changing environment variables (PATH most notably)
http://rix0rrr.github.io/WindowsPathEditor/

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


#http://stackoverflow.com/questions/32539250/how-to-do-a-git-clone-and-enter-the-created-directory/32539370#32539370
# function Invoke-GitClone($url) {
#   $name = $url.Split('/')[-1].Replace('.git', '')
#   & git clone $url $name | Out-Null
#   cd $name
# }
# -> Doesn't work...


# Download stuff:
# https://github.com/chaliy/psurl/

# Use TFS from CLI:
# https://bitbucket.org/Sumo/tfdash/overview

# PSCX source: (download source, has some interesting functions)
# http://pscx.codeplex.com/
# See also: C:\Program Files (x86)\PowerShell Community Extensions\Pscx3\Pscx

---------------------------------------------------------------------------------------

# figure out how Cmder/ConEmu split screen works

# Says "Symlink already exists" while it should: rename the existing file, create symlink
# ie: check if symlink already exists or that destination file already exists

# http://www.hanselman.com/blog/SyncingWindowsLiveWriterDraftsToTheCloudDropboxAndOtherBugFixes.aspx
# for windows live writer

# Desired State configuration
# https://gallery.technet.microsoft.com/scriptcenter/DSC-Resource-Kit-All-c449312d

# Interesting:
# https://gallery.technet.microsoft.com/scriptcenter/Get-RemoteProgram-Get-list-de9fd2b4

# File System Security PowerShell Module
# https://gallery.technet.microsoft.com/scriptcenter/1abd77a5-9c0b-4a2b-acef-90dbb2b84e85

# autohotkey: open and set most often used folder / open in explorer / in cmder new tab?
#(http://www.techunboxed.com/2013/09/how-to-disable-aero-shake-in-windows-8.html)
#~/.bash_aliases

# Library
# Install-Package WindowsAPICodePack-Core
# Install-Package WindowsAPICodePack-Shell
# Microsoft.WindowsAPICodePack.Shell.KnownFolders.Libraries
# http://blogs.technet.com/b/heyscriptingguy/archive/2012/11/11/weekend-scripter-working-with-windows-libraries.aspx

---------------------------------------------------------------------------------------

# H1B
# H1B Speciality Occupation Worker  For individuals having the equivalent of a US bachelor degree (Foreign degrees and/or work experiencemay be found to be equivalent to a US bachelor degree).  6 Years
# http://www.workpermit.com/us/employer_intro.htm


# Make vim the default editor
Set-Environment "EDITOR" "vim" # would this actually overwrite notepad?
Set-Environment "GIT_EDITOR" $Env:EDITOR


# HKUsers drive for Registry
if ((Get-PSDrive HKUsers -ErrorAction SilentlyContinue) -eq $null) { New-PSDrive -Name HKUSERS -PSProvider Registry -Root Registry::HKEY_USERS | Out-Null }

# Taken from: https://github.com/jayharris/dotfiles-windows/blob/master/functions.ps1

# function mklink { cmd /c mklink $args }
# { cmd /c mklink /D "toDir" fromDir }
# /H for a hard link
# https://gist.github.com/jpoehls/2891103

# Basic commands
# function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }
# function touch($file) { "" | Out-File $file -Encoding ASCII }

# Common Editing needs
# function Edit-Hosts { Invoke-Expression "sudo $(if($env:EDITOR -ne $null)  {$env:EDITOR } else { 'notepad' }) $env:windir\system32\drivers\etc\hosts" }
# function Edit-Profile { Invoke-Expression "$(if($env:EDITOR -ne $null)  {$env:EDITOR } else { 'notepad' }) $profile" }

# Sudo
# function sudo() {
# 	if ($args.Length -eq 1) {
# 		start-process $args[0] -verb "runAs"
# 	}
# 	if ($args.Length -gt 1) {
# 		start-process $args[0] -ArgumentList $args[1..$args.Length] -verb "runAs"
# 	}
# }