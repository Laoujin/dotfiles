function Update-RegistryKeys($items) {
	foreach ($item in $items) {
		Update-RegistryKey($item)
	}
}

function Update-RegistryKey($item) {
	switch ($item.type) {
		"fixed" {Set-RegistryKeyValue $item}
		"files" {Execute-RegistryFile $item}
		"toggle" {Toggle-RegistryKeyValue $item}
		default {Write-Error "Unknown registry type: $($item.type)"}
	}
}

function Toggle-RegistryKeyValue($item) {
	Write-Output "$($item.desc): $($item.value)"
	$item.value = $item.values.$($item.value)
	Set-RegistryKeyValue $item
}

function Execute-RegistryFile($item) {
	Write-Output "$($item.desc): $($item.value)"
	$regFile = ".\$($item.files.$($item.value))"
	& regedit /s $regFile
}

function Set-RegistryKeyValue($item) {
	$regPath = "Registry::$($item.hive)\$($item.regPathRaw)"
	
	# Create regKey if it does not exist
	if (Test-RegistryValue $regPath $item.regKey $false) {
		#Write-Output "$($item.regPathRaw) does exist"
	}

	# Check owner
	$currentOwnerName = (Get-Acl $regPath).Owner
	if (-not ($currentOwnerName -eq "BUILTIN\Administrators")) {
		Take-RegistryKeyOwnership $item
		Write-Output "Owner set to Admin for $($item.desc)"
	}

	# Change regKey value
	$currentValue = Get-ItemProperty -Path $regPath -Name $item.regKey | Select-Object -ExpandProperty $item.regKey
	if ($currentValue -ne $item.value) {
		Set-ItemProperty -Path $regPath -Name $item.regKey -Value $item.value
		Write-Output "Updated $($item.desc) regKey"
	}
}

function Test-RegistryValue {
	param([String]$Path, [String]$Name, [Switch]$PassThru)

	process {
		if (Test-Path $Path) {
			$Key = Get-Item -LiteralPath $Path
			if ($Key.GetValue($Name, $null) -ne $null) {
					if ($PassThru) {
						Get-ItemProperty $Path $Name
					} else {
						$true
					}
			} else {
				$false
			}
		} else {
			$false
		}
	}
}



# function Peek-RegistryKey($hive, $key) {
# 	Write-Host "Peeking $hive\$key"
# 	$regPath = "Registry::$hive\$key"
# 	$acl = Get-Acl $regPath
# 	Write-Host $acl
	
# 	$reg = Get-ItemProperty -Path $regPath #-Name $regKey | Select-Object -ExpandProperty $regKey
# 	Write-Host $reg
# }




# registry.json structure:
# {
#    "context": "Windows Explorer",
#    "desc": "On: Show the Desktop, Documents, Downloads, Music, Pictures and Videos folders below 'This PC'",
#    "fileOn": "Explorer_ThisPCFolders_Restore.reg",
#    "fileOff": "Explorer_ThisPCFolders_Remove.reg",
#    "default": "on",
#    "value": "off"
# }

function Take-RegistryKeyOwnership($item) {
	switch ($item.hive) {
		"HKEY_LOCAL_MACHINE" { $hive = [Microsoft.Win32.Registry]::LocalMachine; break }
		"HKEY_CURRENT_USER" { $hive = [Microsoft.Win32.Registry]::CurrentUser; break }
		"HKEY_CLASSES_ROOT" { $hive = [Microsoft.Win32.Registry]::ClassesRoot; break }
		"HKEY_CURRENT_CONFIG" { $hive = [Microsoft.Win32.Registry]::CurrentConfig; break }
		"HKEY_USERS" { $hive = [Microsoft.Win32.Registry]::Users; break }
	}
	$key = $hive.OpenSubKey($item.regPathRaw, [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree, [System.Security.AccessControl.RegistryRights]::TakeOwnership)

	# You must get a blank acl for the key b/c you do not currently have access
	$acl = $key.GetAccessControl([System.Security.AccessControl.AccessControlSections]::None)
	$admin = [System.Security.Principal.NTAccount]"Administrators"
	$acl.SetOwner($admin)
	$key.SetAccessControl($acl)

	# After you have set owner you need to get the acl with the perms so you can modify it.
	$acl = $key.GetAccessControl()
	$access = [System.Security.AccessControl.RegistryRights]"FullControl"
	$inheritance = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit"
	$propagation = [System.Security.AccessControl.PropagationFlags]"None"
	$type = [System.Security.AccessControl.AccessControlType]"Allow"

	$rule = New-Object System.Security.AccessControl.RegistryAccessRule($admin, $access, $inheritance, $propagation, $type)
	$acl.SetAccessRule($rule)
	$key.SetAccessControl($acl)

	$key.Close()
}