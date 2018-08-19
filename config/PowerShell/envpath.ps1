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


function Find-EnvironmentPath {
	$needle = ($args -join " ").TrimEnd("\")
	$needle = [Regex]::Escape($needle)

	$env:PATH.split(";") |
		Where-Object { $_.TrimEnd("\") -match $needle } |
		Sort-Object |
		Get-Unique -AsString
}


function Append-EnvironmentPath {
	$toAppend = ($args -join " ").TrimEnd("\")
	if (-not (Test-Path $toAppend)) {
		echo "Path doesn't exist..."
		echo $toAppend
		return
	}
	$env:PATH = $env:PATH + ";$toAppend"
	$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
	[Environment]::SetEnvironmentVariable("PATH", "$userPath;$toAppend", "User")
}


function Remove-EnvironmentPath {
	$toRemove = ($args -join " ").TrimEnd("\")

	$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
	$changedUserPath = $userPath.Split(";") |
		ForEach-Object { $_.TrimEnd("\") } |
		Where-Object { $_ -ne $toRemove }

	$changedUserPath = $changedUserPath -Join ";"

	if ($userPath -ne $changedUserPath) {
		[Environment]::SetEnvironmentVariable("PATH", "$changedUserPath", "User")
		$env:PATH = [Environment]::GetEnvironmentVariable("PATH", "Machine")
		$env:PATH += ";$changedUserPath"
		return
	}

	echo "Not removed"

	$machinePath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
	$isInMachine = $machinePath.split(";") | Where-Object { $_.Trim("\") -eq $toRemove }
	if ($isInMachine) {
		echo "Is present in Machine scope"
	}

	# TODO: should we try to remove from Machine?
	# Probably need a Test-Admin first
}
