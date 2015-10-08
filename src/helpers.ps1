function ConvertFrom-JsonFile($file) {
	Get-Content $file | Out-String | ConvertFrom-Json
}

function Get-JsonObjectKeys($node) {
	$keys = ($node | Get-Member -MemberType *Property).Name
	[Array]::Reverse($keys)
	return $keys
}

function Check-Command($commandName) {
	return Get-Command $commandName -errorAction SilentlyContinue
}

function Is-Admin {
	# Get the ID and security principal of the current user account
	$myIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
	$myPrincipal = new-object System.Security.Principal.WindowsPrincipal($myIdentity)

	# Check to see if we are currently running "as Administrator"
	return $myPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Restart-AsAdmin {
	$newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell"
	$newProcess.Arguments = $myInvocation.MyCommand.Definition
	$newProcess.Verb = "runas"
	[System.Diagnostics.Process]::Start($newProcess)
}