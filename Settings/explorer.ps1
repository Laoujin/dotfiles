cls

# Customize Windows Explorer
########################
"## WINDOWS EXPLORER ##"
########################
function Enable-Privilege {
 param(
 ## The privilege to adjust. This set is taken from
 ## http://msdn.microsoft.com/en-us/library/bb530716(VS.85).aspx
 [ValidateSet(
 "SeAssignPrimaryTokenPrivilege", "SeAuditPrivilege", "SeBackupPrivilege",
 "SeChangeNotifyPrivilege", "SeCreateGlobalPrivilege", "SeCreatePagefilePrivilege",
 "SeCreatePermanentPrivilege", "SeCreateSymbolicLinkPrivilege", "SeCreateTokenPrivilege",
 "SeDebugPrivilege", "SeEnableDelegationPrivilege", "SeImpersonatePrivilege", "SeIncreaseBasePriorityPrivilege",
 "SeIncreaseQuotaPrivilege", "SeIncreaseWorkingSetPrivilege", "SeLoadDriverPrivilege",
 "SeLockMemoryPrivilege", "SeMachineAccountPrivilege", "SeManageVolumePrivilege",
 "SeProfileSingleProcessPrivilege", "SeRelabelPrivilege", "SeRemoteShutdownPrivilege",
 "SeRestorePrivilege", "SeSecurityPrivilege", "SeShutdownPrivilege", "SeSyncAgentPrivilege",
 "SeSystemEnvironmentPrivilege", "SeSystemProfilePrivilege", "SeSystemtimePrivilege",
 "SeTakeOwnershipPrivilege", "SeTcbPrivilege", "SeTimeZonePrivilege", "SeTrustedCredManAccessPrivilege",
 "SeUndockPrivilege", "SeUnsolicitedInputPrivilege")]
 $Privilege,
 ## The process on which to adjust the privilege. Defaults to the current process.
 $ProcessId = $pid,
 ## Switch to disable the privilege, rather than enable it.
 [Switch] $Disable
 )
 
## Taken from P/Invoke.NET with minor adjustments.
 $definition = @'
 using System;
 using System.Runtime.InteropServices;
 
public class AdjPriv
{
[DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
internal static extern bool AdjustTokenPrivileges(IntPtr htok, bool disall,
ref TokPriv1Luid newst, int len, IntPtr prev, IntPtr relen);
 
[DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
internal static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr phtok);
[DllImport("advapi32.dll", SetLastError = true)]
internal static extern bool LookupPrivilegeValue(string host, string name, ref long pluid);
[StructLayout(LayoutKind.Sequential, Pack = 1)]
internal struct TokPriv1Luid
{
public int Count;
public long Luid;
public int Attr;
}
 
internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
internal const int SE_PRIVILEGE_DISABLED = 0x00000000;
internal const int TOKEN_QUERY = 0x00000008;
internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;
public static bool EnablePrivilege(long processHandle, string privilege, bool disable)
{
bool retVal;
TokPriv1Luid tp;
IntPtr hproc = new IntPtr(processHandle);
IntPtr htok = IntPtr.Zero;
retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
tp.Count = 1;
tp.Luid = 0;
if(disable)
{
tp.Attr = SE_PRIVILEGE_DISABLED;
}
else
{
tp.Attr = SE_PRIVILEGE_ENABLED;
}
retVal = LookupPrivilegeValue(null, privilege, ref tp.Luid);
retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
return retVal;
}
}
'@
 
$processHandle = (Get-Process -id $ProcessId).Handle
$type = Add-Type $definition -PassThru
Write-Host "right before EnablePrivilege"
$type[0]::EnablePrivilege($processHandle, $Privilege, $Disable)
}
# 
#enable-privilege SeTakeOwnershipPrivilege
##This is the Key to take ownership of, I left this in here as an example.  Note I had to change "ChangePermission" to "Take Ownership"
#$key = [Microsoft.Win32.Registry]::ClassesRoot.OpenSubKey('CLSID\{76A64158-CB41-11D1-8B02-00600806D9B6}',[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,[System.Security.AccessControl.RegistryRights]::TakeOwnership)
# 
##You must get a blank acl for the key b/c you do not currently have access
#$acl = $key.GetAccessControl([System.Security.AccessControl.AccessControlSections]::None)
# 
##domain\user is the user that is going to take ownership
#$me = [System.Security.Principal.NTAccount]"domain\user"
#$acl.SetOwner($me)
#$key.SetAccessControl($acl)
# 
##After you have set owner you need to get the acl with the perms so you can modify it.
#$acl = $key.GetAccessControl()
# 
##Domain\user here is the one you are going to give permissions to
#$rule = New-Object System.Security.AccessControl.RegistryAccessRule ("domain\user","FullControl","Allow")
#$acl.SetAccessRule($rule)
#$key.SetAccessControl($acl)
# 
#$key.Close()
#}

function updateRegistryKey($desc, $hive, $regPathRaw, $regKey, $disabledValue, $activeValue) 
{
	$regPath = "Registry::$hive\$regPathRaw"

	# Check owner
	$myName = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
	#$me = New-Object System.Security.Principal.NTAccount($myName)
	
	$currentOwnerName = (Get-Acl $regPath).Owner
	if (-not ($currentOwnerName -eq $myName))
	{
		Write-Host "starting owner change for $regPathRaw"
		# Change owner
		#$currentOwner.SetOwner($me)
		
		# New access permission
#		$registryRights = [System.Security.AccessControl.RegistryRights]"WriteKey"
#		$inheritance = [System.Security.AccessControl.InheritanceFlags]"None"
#		$propagation = [System.Security.AccessControl.PropagationFlags]"None"
#		$accessControlType = [System.Security.AccessControl.AccessControlType]"Allow"
#		$rule = New-Object System.Security.AccessControl.RegistryAccessRule($me, $registryRights, $inheritance, $propagation, $accessControlType)
#		$currentOwner.AddAccessRule($rule)

		switch ($hive)
		{
			"HKEY_LOCAL_MACHINE" { $hive = [Microsoft.Win32.Registry]::LocalMachine; break }
         "HKEY_CURRENT_USER" { $hive = [Microsoft.Win32.Registry]::CurrentUser; break }
         "HKEY_CLASSES_ROOT" { $hive = [Microsoft.Win32.Registry]::ClassesRoot; break }
         "HKEY_CURRENT_CONFIG" { $hive = [Microsoft.Win32.Registry]::CurrentConfig; break }
         "HKEY_USERS" { $hive = [Microsoft.Win32.Registry]::Users; break }
		}
#		$key = $hive.OpenSubKey($regPathRaw, [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree, [System.Security.AccessControl.RegistryRights]::TakeOwnership)
#		Write-Host "key: $key"
#		$acl = $key.GetAccessControl()
		
		#Set-Acl $regPath $currentOwner
		
		#$test = [Microsoft.Win32.Registry]::ClassesRoot.OpenSubKey('CLSID\{76A64158-CB41-11D1-8B02-00600806D9B6}',[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,[System.Security.AccessControl.RegistryRights]::TakeOwnership)
		#echo $test
		
		#New-PSDrive -name HKCR -PSProvider Registry -root HKEY_CLASSES_ROOT | Out-Null #Mounting HKey_ClassesRoot Registry key as a drive - Silent
		$acl = Get-Acl $regPath
		$owner = $acl.Owner
		
		echo "Setting Administrators Group privileges in Windows Registry..."
		$boolResult = enable-privilege SeTakeOwnershipPrivilege
		if(-not $boolResult)
		{
			echo "Privileges could not be elevated. Changing ownership of the registry key would fail."
			return
		}

		$key = $hive.OpenSubKey($regPathRaw, [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree, [System.Security.AccessControl.RegistryRights]::TakeOwnership)

		#$key = [Microsoft.Win32.Registry]::ClassesRoot.OpenSubKey("CLSID\{76A64158-CB41-11D1-8B02-00600806D9B6}",[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,[System.Security.AccessControl.RegistryRights]::takeownership)
		# You must get a blank acl for the key b/c you do not currently have access
		$acl = $key.GetAccessControl([System.Security.AccessControl.AccessControlSections]::None)
		$owner = [System.Security.Principal.NTAccount]"Administrators"
		$acl.SetOwner($owner)
		$key.SetAccessControl($acl)


		# After you have set owner you need to get the acl with the perms so you can modify it.
		$acl = $key.GetAccessControl()
		$person = [System.Security.Principal.NTAccount]"Administrators"
		$access = [System.Security.AccessControl.RegistryRights]"FullControl"
		$inheritance = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit"
		$propagation = [System.Security.AccessControl.PropagationFlags]"None"
		$type = [System.Security.AccessControl.AccessControlType]"Allow"

		$rule = New-Object System.Security.AccessControl.RegistryAccessRule($person,$access,$inheritance,$propagation,$type)
		$acl.SetAccessRule($rule)
		$key.SetAccessControl($acl)

		$key.Close()
		echo "Administrators Group ownership privileges set."
		
		
		
		Write-Host "Owner updated for $desc"
	}

	# Change value
	$currentValue = Get-ItemProperty -Path $regPath -Name $regKey | Select-Object -ExpandProperty $regKey
	if ($currentValue -ne $activeValue)
	{
		Set-ItemProperty -Path $regPath -Name $regKey -Value $activeValue
		Write-Host "Updated $desc"
	}
}

# OneDrive
updateRegistryKey "Remove OneDrive from Navigation pane" 'HKEY_CLASSES_ROOT' 'CLSID\{8E74D236-7F35-4720-B138-1FED0B85EA75}\ShellFolder' "Attributes" 4034920525 4035969101

# Homegroup
# services.msc
# Stop HomeGroup Listener and HomeGroup Provider

# Network
updateRegistryKey "Remove Network from Navigation pane" 'HKEY_CLASSES_ROOT' 'CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder' "Attributes" 2953052260 2962489444

# This PC Folders


# Library
# currently not visible in open/close dialog


# open/save dialogs (Windows 8.1)
#updateRegistryKey "Remove OneDrive" 'HKEY_LOCAL_MACHINE' 'SOFTWARE\Wow6432Node\Classes\CLSID\{8E74D236-7F35-4720-B138-1FED0B85EA75}\ShellFolder' "Attributes" 4034920525 4035969101
#updateRegistryKey "Remove Network" 'HKEY_LOCAL_MACHINE' 'SOFTWARE\Wow6432Node\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder' "Attributes" 2953052260 2962489444