cls

# Customize Windows Explorer
########################
"## WINDOWS EXPLORER ##"
########################
function updateRegistryKey($desc, $regPath, $regKey, $disabledValue, $activeValue) 
{
	$currentValue = Get-ItemProperty -Path "Registry::$regPath" -Name $regKey | Select-Object -ExpandProperty $regKey
	if ($currentValue -ne $activeValue)
	{
		Set-ItemProperty -Path "Registry::$regPath" -Name $regKey -Value $activeValue
		Write-Host "Updated $desc"
	}
}

# OneDrive
updateRegistryKey "Remove OneDrive from Navigation pane" 'HKEY_CLASSES_ROOT\CLSID\{8E74D236-7F35-4720-B138-1FED0B85EA75}\ShellFolder' "Attributes" 4034920525 4035969101

# Homegroup
# services.msc
# Stop HomeGroup Listener and HomeGroup Provider

# Network
updateRegistryKey "Remove Network from Navigation pane" 'HKEY_CLASSES_ROOT\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder' "Attributes" 2953052260 2962489444

# This PC Folders




# open/save dialogs (Windows 8.1)
updateRegistryKey "Remove OneDrive" 'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Classes\CLSID\{8E74D236-7F35-4720-B138-1FED0B85EA75}\ShellFolder' "Attributes" 4034920525 4035969101
#updateRegistryKey "Remove Network" 'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder' "Attributes" 2953052260 2962489444