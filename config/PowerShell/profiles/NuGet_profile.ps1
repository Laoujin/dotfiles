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

Get-Childitem $PSScriptRoot\dotfiles\nuget -Filter *.ps1 -Recurse | Foreach-Object { . $_.FullName }
