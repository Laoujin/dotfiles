### File System functions
### ----------------------------
# Create a new directory and enter it
function CreateAndSet-Directory([String] $path) { 
	New-Item $path -ItemType Directory -ErrorAction SilentlyContinue
	Set-Location $path
}

# Determine size of a file or total size of a directory
# TODO: print the directory
# TODO: fs dirName still gives info on ./ dir...
function Get-DiskUsage([string] $path=(Get-Location).Path) {
	Convert-ToDiskSize `
		( `
			Get-ChildItem .\ -recurse -ErrorAction SilentlyContinue `
			| Measure-Object -property length -sum -ErrorAction SilentlyContinue
		).Sum `
		1
}

### Environment functions
### ----------------------------

# Reload the $env object from the registry
# function Refresh-Environment {
# 	$locations = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
# 				 'HKCU:\Environment'

# 	$locations | ForEach-Object {
# 		$k = Get-Item $_
# 		$k.GetValueNames() | ForEach-Object {
# 			$name  = $_
# 			$value = $k.GetValue($_)
# 			Set-Item -Path Env:\$name -Value $value
# 		}
# 	}
# }

# Set a permanent Environment variable, and reload it into $env
function Set-Environment([String] $variable, [String] $value) {
	[System.Environment]::SetEnvironmentVariable("$variable", "$value","User")
	Invoke-Expression "`$env:${variable} = `"$value`""
}

# Add a folder to $env:Path
# TODO: check if not yet in path. don't do ;;. and keep check that path has to exist
# also create a List-EnvPath (pretty print) and a Fix-Path (kill doubles/unexisting paths)
# rename EnvPath to Path?
# Not persisted... :)
### Modify system environment variable ###
#[Environment]::SetEnvironmentVariable( "Path", $env:Path, [System.EnvironmentVariableTarget]::Machine )

### Modify user environment variable ###
#[Environment]::SetEnvironmentVariable( "INCLUDE", $env:INCLUDE, [System.EnvironmentVariableTarget]::User )
function Prepend-EnvPath([String]$path) { $env:PATH = $env:PATH + ";$path" }
function Prepend-EnvPathIfExists([String]$path) { if (Test-Path $path) { Prepend-EnvPath $path } }
function Append-EnvPath([String]$path) { $env:PATH = $env:PATH + ";$path" }
function Append-EnvPathIfExists([String]$path) { if (Test-Path $path) { Append-EnvPath $path } }


### Utilities
### ----------------------------

# Convert a number to a disk size (12.4K or 5M)
function Convert-ToDiskSize {
	param ( $bytes, $precision='0' )
	foreach ($size in ("B","K","M","G","T")) {
		if (($bytes -lt 1000) -or ($size -eq "T")){
			$bytes = ($bytes).tostring("F0" + "$precision")
			return "${bytes}${size}"
		}
		else { $bytes /= 1KB }
	}
}