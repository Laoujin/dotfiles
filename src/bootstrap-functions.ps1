function Process-Modules($modules, $fromYaml = $false) {
	if ($fromYaml) {
		# Yaml input
		$moduleNames = $modules.GetEnumerator() | Select-Object -Expand Name
	} else {
		# Json input
		$moduleNames = Get-JsonObjectKeys $modules
	}

	foreach ($moduleName in $moduleNames) {
		if ($globalConfig.$moduleName -eq $False) {
			Write-Host "Skipping $moduleName as per config" -ForegroundColor Red
			continue
		}

		$moduleData = $modules.$moduleName

		if (Check-Command $moduleName) {
			&"$moduleName" $moduleData | Write-Background
		} else {
			Write-Host "Couldn't find module: $moduleName"
		}
	}
}




function Process-Programs($programs) {
	foreach ($program in $programs) {
		if (Test-Path "Programs\$program.json") {
			$data = ConvertFrom-JsonFile "Programs\$program.json"
			Process-Program $data
		}
	}
}


function Process-Program($program) {
	if ($program.title) {
		Write-Host "`n" $program.title -ForegroundColor Blue
	}

	if ($program.requires -and -not (Check-Installed $program.requires)) {
		Write-Host "Skipping program $($program.requires) because it is not installed" -ForegroundColor Red
		return
	}

	Process-Modules $program.modules
}
