# Basic commands
function touch($file) {
	$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
	$path = Get-Location
	$path = Join-Path -Path $path -ChildPath $file
	[System.IO.File]::WriteAllText($path, "", $Utf8NoBomEncoding)
}
# Append: Add-Content fileName "content"


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

Set-Alias cwd Clipboard-Working-Directory

function Clipboard-Working-Directory() {
	$pwd.Path | Clip
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
# TODO: This is builtin in PS?
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

# Empty the Recycle Bin on all drives
function Empty-RecycleBins {
	$RecBin = (New-Object -ComObject Shell.Application).Namespace(0xA)
	$RecBin.Items() | %{Remove-Item $_.Path -Recurse -Confirm:$false}
}

# TODO Extract a .zip file is now in PowerShell X?
# https://gist.github.com/stefanteixeira/0428e8ade6be09d94b90
# https://stackoverflow.com/questions/1153126/how-to-create-a-zip-archive-with-powershell
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

# Retrieve size of recycle bin: https://gist.github.com/maul-esel/1808118
#include <SHQueryRecycleBin>
# SHQueryRecycleBin("C:\", bytes, items)
# MsgBox % "The recycle bin on drive C:\ contains " . items . " items (" . bytes . " bytes)."

# /*
# Function: SHQueryRecycleBin
# Retrieves the size of the Recycle Bin and the number of items in it, for a specified drive.
# Parameters:
# 	STR path - the path of the root drive on which the Recycle Bin is located. This parameter can contain a string formatted with the drive, folder, and subfolder names (C:\Windows\System...).
# 	[byRef] INT64 outSize - receives the total size of all the objects in the specified Recycle Bin, in bytes.
# 	[byRef] INT64 outNumber - receives the total number of items in the specified Recycle Bin.
# Returns:
# 	BOOL success - true on success, false otherwise
# Requirements:
# 	OS - Windows 2000 Professional, Windows XP / Windows 2000 Server or higher
# 	AutoHotkey - any AutoHotkey version (classic, _L, v2)
# */
# SHQueryRecycleBin(path, ByRef outSize, ByRef outNumber)
# {
# 	VarSetCapacity(SHQUERYRBINFO, 20, 0) ; create SHQUERYRBINFO structure
# 	, NumPut(20, SHQUERYRBINFO, 00, "UInt") ; fill cbSize member
# 	, hr := DllCall("Shell32\SHQueryRecycleBin" . (A_IsUnicode ? "W" : "A"), "Str", path, A_PtrSize ? "Ptr" : "UInt", &SHQUERYRBINFO, "Int") ; call function
# 	, outSize := NumGet(SHQUERYRBINFO, 4, "Int64") ; retrieve data (bytes)
# 	, outNumber := NumGet(SHQUERYRBINFO, 12, "Int64") ; retrieve item count
# 	return hr >= 0x00 ; return BOOL
# }
