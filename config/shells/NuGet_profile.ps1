# Location: %USERPROFILE%\Documents\WindowsPowerShell ($profile)

# NuGet:
# https://docs.microsoft.com/en-us/nuget/tools/powershell-reference
Set-Alias ip Install-Package
Set-Alias unip Uninstall-Package

# Other commands:
# Get-Package -ListAvailable -Filter elmah # -AllVersions
# Get-Package -Updates
# Find-Package EntityFramework -version 6.1.1 # -AllVersions
# Install-Package -Version 1.0 -IncludePrerelease
# Update-Package, Sync-Package, Open-PackagePage


# Entity Framework
# https://docs.microsoft.com/en-us/ef/core/miscellaneous/cli/powershell
Set-Alias em Enable-RealMigrations
Set-Alias am Add-RealMigration
Set-Alias ad Add-RealMigration
Set-Alias ud Update-RealDatabase
Set-Alias udv Update-RealDatabaseVerbosely
Set-Alias gam Get-AppliedMigrations
Set-Alias lm List-Migrations # List last $listMigrationsCount
Set-Alias lam List-AllMigrations

# Other aliases
Set-Alias cs Get-ConnectionStrings

# Execute commands against first ProjectName to end with one of these:
$isLikelyDbContextProject = ".DataAccess", ".Back", ".Migrations"
$listMigrationsCount = 5


# Other commands:
# EF 6:
# https://coding.abel.nu/2012/03/ef-migrations-command-reference/
# Add-EFProvider, Add-EFDefaultConnectionFactory, Initialize-EFConfiguration

# EF Core:
# Remove-Migration, Scaffold-DbContext, Script-Migration, Drop-Database


function Enable-RealMigrations {
	$project = Get-DbContextProjectName
	Enable-Migrations -Project $project
}

function Get-AppliedMigrations {
	$project = Get-DbContextProjectName
	Get-Migrations -Project $project
}

function Add-RealMigration($name = "test") {
	$project = Get-DbContextProjectName
	Add-Migration $name -Project $project
}

function Update-RealDatabase([int]$targetMigration = 0) {
	$project = Get-DbContextProject
	if ($targetMigration -eq 0) {
		Update-Database -Project $project.ProjectName
	} else {
		$migration = Get-MigrationsTable | Where-Object {$_.Index -eq $targetMigration}
		echo "Migrating to last migration $targetMigration => $($migration.name)"
		Update-Database -Project $project.ProjectName -TargetMigration $migration.name
	}
}

function Get-MigrationsTable {
	$project = Get-DbContextProject
	$projectPath = Split-Path -Path $project.FullName

	$migrations = Get-ChildItem "$projectPath\Migrations" |
		Where-Object { Test-MigrationName $_.Name } |
		Sort-Object Name -Descending

	return $migrations | ForEach-Object -Begin {$idx = 0} -Process {
		$withoutExt = $_.Name.Substring(0, $_.Name.LastIndexOf("."))
		$migrationName = $withoutExt.Substring($withoutExt.IndexOf("_") + 1)
		$dateStr = $_.Name.Substring(0, $_.Name.IndexOf("_"))
		$date = [DateTime]::ParseExact($dateStr.Substring(0, 12), "yyyyMMddHHmm", $null)

		$_ | Select-Object -Property `
			@{l='Index';e={"$idx"}}, `
			@{l='Name'; e={$migrationName}}, `
			@{l='Created'; e={$date.ToString("g")}}, `
			@{l='FullName'; e={$_.Name}}

		$idx -= 1
	}
}

function List-Migrations {
	$migrations = Get-MigrationsTable
	$migrations | Select-Object -First $listMigrationsCount | Format-Table -AutoSize
}

function List-AllMigrations {
	Get-MigrationsTable | Sort-Object FullName | Format-Table -AutoSize
}

function Test-MigrationName($fileName) {
	return $fileName -match "^(\d[^.]+)\.(cs|vb)$"
}

function Update-RealDatabaseVerbosely {
	Update-RealDatabase -Verbose
}

function Get-DbContextProject {
	return Get-Project -All |
		Where-Object {
			if ($_.ProjectName.LastIndexOf(".") -gt -1) {
				return $isLikelyDbContextProject -match $_.ProjectName.Substring($_.ProjectName.LastIndexOf("."))
			} else {
				return $false
			}
		} | Select -First 1
}

function Get-DbContextProjectName {
	$project = Get-DbContextProject
	return $project.ProjectName
}

function Get-ConnectionStrings {
	$project = Get-DbContextProject
	$projectPath = Split-Path -Path $project.FullName

	$configPath = "$projectPath\Web.config"
	if (-not (Test-Path $configPath)) {
		$configPath = "$projectPath\App.config"
	}

	echo "Configuration file: $configPath"

	$xdoc = [xml](Get-Content $configPath)
	$xdoc.configuration.connectionStrings.SelectNodes("add") | Format-Table -AutoSize
}
