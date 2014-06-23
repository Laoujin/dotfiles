##########################
"## Install Chocolatey ##"
##########################
#@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%systemdrive%\chocolatey\bin

# Tell chololatey to not install in root c:
#Write-Host "currentvalue: $env:chocolatey_bin_root"
#if ($env:chocolatey_bin_root -eq $null) {
#	[Environment]::SetEnvironmentVariable("chocolatey_bin_root", "c:\unix", "User")
#	Write-Host "chocolatey_bin_root set to c:\unix"
#}



#cinst dexpot # needs evaluation
