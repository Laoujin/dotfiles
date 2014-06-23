cls

# Customize Windows Explorer
########################
"## WINDOWS EXPLORER ##"
########################
## Code from http://social.technet.microsoft.com/Forums/windowsserver/en-US/e718a560-2908-4b91-ad42-d392e7f8f1ad/take-ownership-of-a-registry-key-and-change-permissions?forum=winserverpowershell#04b180cc-d75c-4491-8060-be451882ba44
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
		   if (disable)
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

if (-not ("AdjPriv" -as [type]))
{
	$processHandle = (Get-Process -id $PID).Handle
	$type = Add-Type $definition -PassThru
	$success = $type[0]::EnablePrivilege($processHandle, "SeTakeOwnershipPrivilege", [bool]'')
	Write-Host "Enable SeTakeOwnershipPrivilege is: $success"
}

function Test-RegistryValue
{
    param(
        [Alias("PSPath")]
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [String]$Path
        ,
        [Parameter(Position = 1, Mandatory = $true)]
        [String]$Name
        ,
        [Switch]$PassThru
    ) 

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

function updateRegistryKey($desc, $hive, $regPathRaw, $regKey, $disabledValue, $activeValue) 
{
	$regPath = "Registry::$hive\$regPathRaw"
	
	# Create regKey if it does not exist
	if (Test-RegistryValue $regPath $regKey $false)
	{
		Write-Host "$regPathRaw does exist"
	}

	# Check owner
	$currentOwnerName = (Get-Acl $regPath).Owner
	if (-not ($currentOwnerName -eq "BUILTIN\Administrators"))
	{
		# Change owner
		switch ($hive)
		{
			"HKEY_LOCAL_MACHINE" { $hive = [Microsoft.Win32.Registry]::LocalMachine; break }
         "HKEY_CURRENT_USER" { $hive = [Microsoft.Win32.Registry]::CurrentUser; break }
         "HKEY_CLASSES_ROOT" { $hive = [Microsoft.Win32.Registry]::ClassesRoot; break }
         "HKEY_CURRENT_CONFIG" { $hive = [Microsoft.Win32.Registry]::CurrentConfig; break }
         "HKEY_USERS" { $hive = [Microsoft.Win32.Registry]::Users; break }
		}
		$key = $hive.OpenSubKey($regPathRaw, [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree, [System.Security.AccessControl.RegistryRights]::TakeOwnership)

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
		Write-Host "Owner set to Admin for $desc"
	}

	# Change regKey value
	$currentValue = Get-ItemProperty -Path $regPath -Name $regKey | Select-Object -ExpandProperty $regKey
	if ($currentValue -ne $activeValue)
	{
		Set-ItemProperty -Path $regPath -Name $regKey -Value $activeValue
		Write-Host "Updated $desc regKey"
	}
}

function peekRegKey($hive, $key)
{
	Write-Host "Peeking $hive\$key"
	$regPath = "Registry::$hive\$key"
	$acl = Get-Acl $regPath
	Write-Host $acl
	
	$reg = Get-ItemProperty -Path $regPath #-Name $regKey | Select-Object -ExpandProperty $regKey
	Write-Host $reg
}

# OneDrive
#updateRegistryKey "OneDrive icon in Navigation pane" 'HKEY_CLASSES_ROOT' 'CLSID\{8E74D236-7F35-4720-B138-1FED0B85EA75}\ShellFolder' "Attributes" 4034920525 4035969101

# Homegroup
# services.msc
# Stop HomeGroup Listener and HomeGroup Provider

# Network
updateRegistryKey "Network icon in Navigation pane" 'HKEY_CLASSES_ROOT' 'CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder' "Attributes" 2953052260 2962489444

# This PC Folders

#peekRegKey "HKEY_CURRENT_USER" "Software\Classes\CLSID\{59031a47-3f72-44a7-89c5-5595fe6b30ee}"

updateRegistryKey "User folder group in Windows Explorer" 'HKEY_CURRENT_USER' 'Software\Classes\CLSID\{59031a47-3f72-44a7-89c5-5595fe6b30ee}' "System.IsPinnedToNameSpaceTree" 00000000 00000001

# Library
# currently not visible in open/close dialog


# open/save dialogs (Windows 8.1)
#updateRegistryKey "OneDrive in open/save dialogs" 'HKEY_LOCAL_MACHINE' 'SOFTWARE\Wow6432Node\Classes\CLSID\{8E74D236-7F35-4720-B138-1FED0B85EA75}\ShellFolder' "Attributes" 4034920525 4035969101
#updateRegistryKey "Network in open/save dialogs" 'HKEY_LOCAL_MACHINE' 'SOFTWARE\Wow6432Node\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder' "Attributes" 2953052260 2962489444