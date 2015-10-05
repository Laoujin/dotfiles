# Start IIS Express Server with an optional path and port
# function Start-IISExpress {
# 	[CmdletBinding()]
# 	param (
# 		[String] $path = (Get-Location).Path,
# 		[Int32]  $port = 3000
# 	)

# 	if ((Test-Path "${env:ProgramFiles}\IIS Express\iisexpress.exe") -or (Test-Path "${env:ProgramFiles(x86)}\IIS Express\iisexpress.exe")) {
# 		$iisExpress = Resolve-Path "${env:ProgramFiles}\IIS Express\iisexpress.exe" -ErrorAction SilentlyContinue
# 		if ($iisExpress -eq $null) { $iisExpress = Get-Item "${env:ProgramFiles(x86)}\IIS Express\iisexpress.exe" }

# 		& $iisExpress @("/path:${path}") /port:$port
# 	} else { Write-Warning "Unable to find iisexpress.exe"}
# }

# Extract a .zip file
# function Unzip-File {
# 	<#
# 	.SYNOPSIS
# 	   Extracts the contents of a zip file.

# 	.DESCRIPTION
# 	   Extracts the contents of a zip file specified via the -File parameter to the
# 	location specified via the -Destination parameter.

# 	.PARAMETER File
# 		The zip file to extract. This can be an absolute or relative path.

# 	.PARAMETER Destination
# 		The destination folder to extract the contents of the zip file to.

# 	.PARAMETER ForceCOM
# 		Switch parameter to force the use of COM for the extraction even if the .NET Framework 4.5 is present.

# 	.EXAMPLE
# 	   Unzip-File -File archive.zip -Destination .\d

# 	.EXAMPLE
# 	   'archive.zip' | Unzip-File

# 	.EXAMPLE
# 		Get-ChildItem -Path C:\zipfiles | ForEach-Object {$_.fullname | Unzip-File -Destination C:\databases}

# 	.INPUTS
# 	   String

# 	.OUTPUTS
# 	   None

# 	.NOTES
# 	   Inspired by:  Mike F Robbins, @mikefrobbins

# 	   This function first checks to see if the .NET Framework 4.5 is installed and uses it for the unzipping process, otherwise COM is used.
# 	#>
# 	[CmdletBinding()]
# 	param (
# 		[Parameter(Mandatory=$true, ValueFromPipeline=$true)]
# 		[string]$File,

# 		[ValidateNotNullOrEmpty()]
# 		[string]$Destination = (Get-Location).Path
# 	)

# 	$filePath = Resolve-Path $File
# 	$destinationPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)

# 	if (($PSVersionTable.PSVersion.Major -ge 3) -and
# 	   ((Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue).Version -like "4.5*" -or
# 	   (Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" -ErrorAction SilentlyContinue).Version -like "4.5*")) {

# 		try {
# 			[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
# 			[System.IO.Compression.ZipFile]::ExtractToDirectory("$filePath", "$destinationPath")
# 		} catch {
# 			Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
# 		}
# 	} else {
# 		try {
# 			$shell = New-Object -ComObject Shell.Application
# 			$shell.Namespace($destinationPath).copyhere(($shell.NameSpace($filePath)).items())
# 		} catch {
# 			Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
# 		}
# 	}
# }



### Visual Studio
### ----------------------------

# Configure Visual Studio functions only if it has been installed
# if (($env:VSINSTALLDIR -ne $null) -and (Test-Path $env:VSINSTALLDIR)) {
# 	$vsInstall = $env:VSINSTALLDIR
# 	function Start-VisualStudio ([string] $solutionFile) {
# 		$devenv = Resolve-Path "$vsInstall\Common7\IDE\devenv.exe"
# 		if (($solutionFile -eq $null) -or ($solutionFile -eq "")) {
# 			$solutionFile = (Get-ChildItem -Filter "*.sln" | Select-Object -First 1).Name
# 		}
# 		if (($solutionFile -ne $null) -and ($solutionFile -ne "") -and (Test-Path $solutionFile)) {
# 			start-process $devenv -ArgumentList $solutionFile
# 		} else {
# 			start-process $devenv
# 		}
# 	}
# 	Set-Alias -name vs -Value Start-VisualStudio

# 	function Start-VisualStudioAsAdmin ([string] $solutionFile) {
# 		$devenv = Resolve-Path "$vsInstall\Common7\IDE\devenv.exe"
# 		if (($solutionFile -eq $null) -or ($solutionFile -eq "")) {
# 			$solutionFile = (Get-ChildItem -Filter "*.sln" | Select-Object -First 1).Name
# 		}
# 		if (($solutionFile -ne $null) -and ($solutionFile -ne "") -and (Test-Path $solutionFile)) {
# 			start-process $devenv -ArgumentList $solutionFile -verb "runAs"
# 		} else {
# 			start-process $devenv -verb "runAs"
# 		}
# 	}
# 	Set-Alias -name vsadmin -Value Start-VisualStudioAsAdmin

# 	function Install-VSExtension($url) {
# 		$vsixInstaller = Join-Path $env:DevEnvDir "VSIXInstaller.exe"
# 		Write-Output "Downloading ${url}"
# 		$extensionFile = (curlex $url)
# 		Write-Output "Installing $($extensionFile.Name)"
# 		$result = Start-Process -FilePath `"$vsixInstaller`" -ArgumentList "/q $($extensionFile.FullName)" -Wait -PassThru;
# 	}
# }











# Taken from: https://github.com/jayharris/dotfiles-windows/blob/master/functions.ps1

# function mklink { cmd /c mklink $args }
# { cmd /c mklink /D "toDir" fromDir }
# /H for a hard link
# https://gist.github.com/jpoehls/2891103

# Basic commands
# function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }
# function touch($file) { "" | Out-File $file -Encoding ASCII }

# Common Editing needs
# function Edit-Hosts { Invoke-Expression "sudo $(if($env:EDITOR -ne $null)  {$env:EDITOR } else { 'notepad' }) $env:windir\system32\drivers\etc\hosts" }
# function Edit-Profile { Invoke-Expression "$(if($env:EDITOR -ne $null)  {$env:EDITOR } else { 'notepad' }) $profile" }

# Sudo
# function sudo() {
# 	if ($args.Length -eq 1) {
# 		start-process $args[0] -verb "runAs"
# 	}
# 	if ($args.Length -gt 1) {
# 		start-process $args[0] -ArgumentList $args[1..$args.Length] -verb "runAs"
# 	}
# }

# Remove this
# System Update - Update RubyGems, NPM, and their installed packages
# function System-Update() {
# 	gem update --system
# 	gem update
# 	npm install npm -g
# 	npm update -g
# }

# Reload the Shell
# function Reload-Powershell {
# 	$newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
# 	[System.Diagnostics.Process]::Start($newProcess);
# 	exit
# }

# Download a file into a temporary folder
# function curlex($url) {
# 	$uri = new-object system.uri $url
# 	$filename = $name = $uri.segments | Select-Object -Last 1
# 	$path = join-path $env:Temp $filename
# 	if( test-path $path ) { rm -force $path }

# 	(new-object net.webclient).DownloadFile($url, $path)

# 	return new-object io.fileinfo $path
# }

# Empty the Recycle Bin on all drives
# function Empty-RecycleBin {
# 	$RecBin = (New-Object -ComObject Shell.Application).Namespace(0xA)
# 	$RecBin.Items() | %{Remove-Item $_.Path -Recurse -Confirm:$false}
# }

# TODO: Remove, I have MiKe for this
# Sound Volume
# function Get-SoundVolume { [Audio]::Volume }
# function Set-SoundVolume([Int32] $volume) { [Audio]::Volume = ($volume / 100)}
# function Set-SoundMute { [Audio]::Mute = $true }
# function Set-SoundUnmute { [Audio]::Mute = $false }