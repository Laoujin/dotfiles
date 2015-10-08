# Easier Navigation
${function:~} = { Set-Location ~ }
${function:Set-ParentLocation} = { Set-Location .. } # PoSh won't allow ${function:..} because of an invalid path error, so...
Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }

${function:Unblock-Dir} = { Get-ChildItem * -Recursive | Unblock-File }

Set-Alias fs Get-DiskUsage
Set-Alias mkd CreateAndSet-Directory
${function:rmd} = { Remove-Item -Force -Recurse $args[0] }

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

# TODO Extract a .zip file
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