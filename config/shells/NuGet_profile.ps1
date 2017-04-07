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


# Entity Framework 6
# https://docs.microsoft.com/en-us/ef/core/miscellaneous/cli/powershell
Set-Alias em Enable-RealMigrations
Set-Alias am Add-RealMigration
Set-Alias ad Add-RealMigration
Set-Alias ud Update-RealDatabase
Set-Alias udv Update-RealDatabaseVerbosely

# Execute commands against first ProjectName to end with one of these:
$isLikelyDbContextProject = ".DataAccess", ".Back"


# Other commands:
# Remove-Migration, Scaffold-DbContext, Script-Migration, Drop-Database


function Enable-RealMigrations {
	$project = Get-DbContextProjectName
	Enable-Migration -Project $project
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
		$projectPath = Split-Path -Path (Get-Project).FullName
		$migrations = List-Migrations

		# How to make ctrl+space list all available migrations and allow selection with arrow keys?

		$migrationName = "MatchShouldBePlayed"
		# Update-Database -Project $project.ProjectName -TargetMigration $migrationName
	}
}

function List-Migrations {
	# List of migrations in descending order:
	# -1    date     name
	# -2    date     name
	$migrations = Get-ChildItem "$projectPath\Migrations" | Where-Object { Test-MigrationName $_.Name }

	# TODO: we zaten hier:
	# Select the date created & migrationname and filename
	# sort them descending on filename
	# take last 10

	return $migrations
}

function Test-MigrationName($fileName) {
	return $fileName -match "^(\d[^.]+)\.cs$"
}

function Get-MigrationName($fileName) {
	$fileName -match "([^.]+)\.cs$"
	return $Matches[0]
}

function Update-RealDatabaseVerbosely {
	Update-RealDatabase -Verbose
}

function Get-DbContextProject {
	$dbContextProjects = Get-Project -All | Where-Object { $isLikelyDbContextProject -match $_.ProjectName.Substring($_.ProjectName.LastIndexOf(".")) }
	return $dbContextProjects[0]
}

function Get-DbContextProjectName {
	$project = Get-DbContextProject
	return $project.ProjectName
}




# Add these Visual Studio shortcuts:
# - Add existing file
# - Add new file
# - Add existing project
# - Add new project
# - Close solution
# - Open recent solutions
