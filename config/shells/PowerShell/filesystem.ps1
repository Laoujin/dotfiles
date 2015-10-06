# Easier Navigation
${function:~} = { Set-Location ~ }
${function:Set-ParentLocation} = { Set-Location .. } # PoSh won't allow ${function:..} because of an invalid path error, so...
Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }

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