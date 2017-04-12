# Environment Variables
Set-Alias se Set-Environment
Set-Alias re Refresh-Environment

# $env:PATH
Set-Alias fp Find-EnvironmentPath
Set-Alias ap Append-EnvironmentPath
Set-Alias delp Remove-EnvironmentPath

# TODO: List-Environment: Key, Value, Scope
# TODO: List-EnvironmentPath: Directory, Exists, Scope

# Set a permanent Environment variable, and reload it into $env
function Set-Environment([String]$key, [String]$value) {
	[System.Environment]::SetEnvironmentVariable("$key", "$value", "User")
	Set-Item -Path Env:$key -Value $value
}


# Reload $env from registry
function Refresh-Environment {
	$locations = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment', 'HKCU:\Environment'
	$locations | ForEach-Object {
		$k = Get-Item $_
		$k.GetValueNames() | ForEach-Object {
			$name = $_
			$value = $k.GetValue($_)
			Set-Item -Path Env:$name -Value $value
		}
	}

	# Put Machine and User $env:PATH together
	$machinePath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
	$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
	$Env:PATH = "$machinePath;$userPath"
}




function Find-EnvironmentPath([String]$needle) {
	$env:PATH.split(";") |
		Where-Object { $_ -match $needle.Trim("\") } |
		Sort-Object |
		Get-Unique -AsString
}


function Append-EnvironmentPath([String]$path) {
	if (-not (Test-Path $path)) {
		echo "Path doesn't exist..."
		echo $path
		return
	}
	$env:PATH = $env:PATH + ";$path"
	$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
	[Environment]::SetEnvironmentVariable("PATH", "$userPath;$path", "User")
}


function Remove-EnvironmentPath([String]$path) {
	# TODO: parse a path with spaces properly

	$path = $path.TrimEnd("\")

	$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
	$changedUserPath = $userPath.Split(";") |
		ForEach-Object { $_.TrimEnd("\") } |
		Where-Object { $_ -ne $path }

	$changedUserPath = $changedUserPath -Join ";"

	if ($userPath -ne $changedUserPath) {
		Set-Environment PATH $changedUserPath
		return
	}

	echo "Not removed"

	$machinePath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
	$isInMachine = $machinePath.split(";") | Where-Object { $_.Trim("\") -eq $path }
	if ($isInMachine) {
		echo "Is present in Machine scope"
	}

	# TODO: should we try to remove from Machine?
	# Probably need a Test-Admin first
}
