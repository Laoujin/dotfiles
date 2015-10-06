Append-EnvPath "C:\Program Files\Sublime Text 3"
Append-EnvPath "C:\Program Files (x86)\MarkdownPad 2"

Set-Alias vgrt vagrant


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