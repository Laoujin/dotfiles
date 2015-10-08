function Download-File {
	param (
		[string]$url,
		[string]$file
	)
	Write-Host "Downloading $url to $file"
	$downloader = new-object System.Net.WebClient
	$downloader.DownloadFile($url, $file)
}

# Useful Windows dotfiles?
# https://github.com/jayharris/dotfiles-windows/blob/master/windows.ps1

# Configure IIS
# Write-Output "Configuring IIS. This may take a while..."
# & dism.exe /Online /Enable-Feature /All `
# 	/FeatureName:NetFx3 `
# 	/FeatureName:IIS-WebServerRole `
# 	/FeatureName:IIS-WebServer `
# 	/FeatureName:IIS-CommonHttpFeatures `
# 	/FeatureName:IIS-HttpErrors `
# 	/FeatureName:IIS-ApplicationDevelopment `
# 	/FeatureName:IIS-NetFxExtensibility `
# 	/FeatureName:IIS-NetFxExtensibility45 `
# 	/FeatureName:IIS-HealthAndDiagnostics `
# 	/FeatureName:IIS-HttpLogging `
# 	/FeatureName:IIS-Security `
# 	/FeatureName:IIS-RequestFiltering `
# 	/FeatureName:IIS-Performance `
# 	/FeatureName:IIS-HttpCompressionDynamic `
# 	/FeatureName:IIS-WebServerManagementTools `
# 	/FeatureName:IIS-WindowsAuthentication `
# 	/FeatureName:IIS-StaticContent `
# 	/FeatureName:IIS-DefaultDocument `
# 	/FeatureName:IIS-DirectoryBrowsing `
# 	/FeatureName:IIS-WebSockets `
# 	/FeatureName:IIS-ASPNET `
# 	/FeatureName:IIS-ASPNET45 `
# 	/FeatureName:IIS-ISAPIExtensions `
# 	/FeatureName:IIS-ISAPIFilter `
# 	/FeatureName:IIS-BasicAuthentication `
# 	/FeatureName:IIS-HttpCompressionStatic `
# 	/FeatureName:IIS-ManagementConsole `
# 	/FeatureName:WCF-Services45 `
# 	/FeatureName:WCF-TCP-PortSharing45 `
# 	/FeatureName:NetFx4-AdvSrvs `
# 	/FeatureName:NetFx4Extended-ASPNET45 | Out-Null

# Start IIS Express Server with an optional path and port
# function Start-IISExpress {
# 	[CmdletBinding()]
# 	param (
# 		[String] $path = (Get-Location).Path,
# 		[Int32]  $port = 3000
# 	)

# 	if ((Test-Path "${env:ProgramFiles}\IIS Express\iisexpress.exe") -or (Test-Path "${env:ProgramFiles(x86)}\IIS Express\iisexpress.exe")) {
# 		$iisExpress = Resolve-Path "${env:ProgramFiles}\IIS Express\iisexpress.exe" -ErrorAction SilentlyContinue
# 		if ($iisExpress -eq $null) { $iisExpress = Get-Item "${env:ProgramFiles(x86)}\IIS Express\iisexpress.exe" }

# 		& $iisExpress @("/path:${path}") /port:$port
# 	} else { Write-Warning "Unable to find iisexpress.exe"}
# }