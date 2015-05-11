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

function Combine-Configs($commonConfig, $extraConfig) {
	$commonConfig = ConvertFrom-JsonFile $commonConfig
	$extraConfig = ConvertFrom-JsonFile $extraConfig

	# Some stuff needs to be done on certain DOMAINS\USERS only:
	$domain = [Environment]::UserDomainName
	$user = [Environment]::UserName
	if ($extraConfig.$domain.$user) {
		$userModules = Get-JsonObjectKeys $extraConfig.$domain.$user
		foreach ($moduleName in $userModules) {
			$module = $extraConfig.$domain.$user.$moduleName
			if ($commonConfig.modules.$moduleName) {
				if ($commonConfig.modules.$moduleName -is [System.Array]) {
					$commonConfig.modules.$moduleName += $module
				} else {
					if ($commonConfig.modules.$moduleName."aliases" -isNot [system.array]) {
						throw "not yet implemented :p" # they say this can be solved using recursion
						# implementation done for shells-domain.json only
					}
					$commonConfig.modules.$moduleName."aliases" += $module."aliases"
				}
			} else {
				$commonConfig.modules | Add-Member $moduleName $module
			}
		}
	}
	return $commonConfig
}

function Process-Program($program) {
	if ($program.requires -and -not (Check-Installed $program.requires)) {
		Write-Output "Skipping program $($program.requires)"
		return
	}

	if ($program.title) {
		Write-Title $program.title
	}

	Process-Modules $program.modules
}

function Process-Modules($modules) {
	$moduleNames = Get-JsonObjectKeys $modules
	foreach ($moduleName in $moduleNames) {
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