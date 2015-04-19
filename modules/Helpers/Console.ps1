function Write-Title($title, $addSpace = $true) {
	if ($addSpace) {
		Write-Host
	}

	$titleHeader = "#" * ($title.length + 6)
	Write-Host $titleHeader -ForegroundColor darkgreen
	Write-Host "## $title ##" -ForegroundColor darkgreen
	Write-Host $titleHeader -ForegroundColor darkgreen
}

function Write-Background {
	process {
		Write-Host $_ -ForegroundColor darkgray
	}
}

function Process-Program($program) {
	if ($program.title) {
		Write-Title $program.title
	}

	Process-Modules $program.modules
}

function Process-Modules($modules) {
	$moduleNames = ($modules | Get-Member -MemberType *Property).Name
	foreach ($moduleName in $moduleNames) {
		$moduleData = $modules.$moduleName

		if (Check-Command $moduleName) {
			&"$moduleName" $moduleData | Write-Background
		} else {
			Write-Host "Couldn't find module: $moduleName"
		}
	}
}

function Create-Links($links) {
	foreach ($link in $links) {
		Create-Link $link
	}
}

function Create-StartupLinks($files) {
	$startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\"

	Write-Title "START WITH WINDOWS"
	Write-Output "Programs starting when Windows starts" | Write-Background
	Write-Output "Dir: $startupFolder" | Write-Background

	foreach ($file in $files) {
		Create-Shortcut $file $startupFolder
	}
}

function Process-Programs($programs) {
	Write-Title "PROGRAMS"
	foreach ($program in $programs) {
		if (Test-Path "Programs\$program.json") {
			$data = ConvertFrom-JsonFile "Programs\$program.json"
			Process-Program $data
		}
	}
}