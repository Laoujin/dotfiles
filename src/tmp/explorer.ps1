Write-Title "WINDOWS EXPLORER"

$currentPath = Split-Path $MyInvocation.PSCommandPath

. "$currentPath\Helpers\AdjPriv.ps1"
if (-not ("AdjPriv" -as [type])) {
	$processHandle = (Get-Process -id $PID).Handle
	$type = Add-Type $definition -PassThru
	$success = $type[0]::EnablePrivilege($processHandle, "SeTakeOwnershipPrivilege", [bool]'')
	Write-Host "Enable SeTakeOwnershipPrivilege is: $success"
}

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




Write-Host