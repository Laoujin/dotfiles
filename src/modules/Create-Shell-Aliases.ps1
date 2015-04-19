function Create-Shell-Aliases($config) {
	if ($config.aliases.length) {
		foreach ($alias in $config.aliases) {
			$powershell += "`n`${function:$($alias.alias)} = { Set-Location `"$($alias.cd)`" }"

			$bashPath = $alias.cd
			foreach ($drive in $config.drives) {
				$bashPath = $bashPath.Replace($drive.powershell, $drive.bash)
			}
			$bashPath = $bashPath.Replace("\", "/")
			$shell += "`nalias $($alias.alias)=`"cd $bashPath`""

			$echo += ", $($alias.alias)"
		}

		$echo = "Aliases: $($echo.Substring(2))"
		Write-Output $echo
		$echo = "`n`necho `"$echo`""

		$powershellPath = Join-Path (Get-Location) "shells\Microsoft.PowerShell_aliases.ps1"
		[System.IO.File]::WriteAllLines($powershellPath, $powershell + $echo)

		$shellPath = Join-Path (Get-Location) "shells\bash_aliases.sh"
		[System.IO.File]::WriteAllLines($shellPath, $shell + $echo)
	}
}