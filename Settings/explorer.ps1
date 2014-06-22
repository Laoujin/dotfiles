cls

# Customize Windows Explorer
########################
"## WINDOWS EXPLORER ##"
########################
function updateRegistryKey($desc, $regPath, $regKey, $old, $new) 
{
	$current = Get-ItemProperty -Path "Registry::$regPath" -Name $regKey
	if ($current -ne $new)
	{
		Set-ItemProperty -Path "Registry::$regPath" -Name $regKey -Value $new
		Write-Host "Updated $desc"
	}
}

# OneDrive shortcut icon
updateRegistryKey "Remove OneDrive from Navigation pane" 'HKEY_CLASSES_ROOT\CLSID\{8E74D236-7F35-4720-B138-1FED0B85EA75}\ShellFolder' "Attributes" 4034920525 4035969101
updateRegistryKey "Remove OneDrive from open/close dialogs (Windows 8.1)" 'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Classes\CLSID\{8E74D236-7F35-4720-B138-1FED0B85EA75}\ShellFolder' "Attributes" 4034920525 4035969101
