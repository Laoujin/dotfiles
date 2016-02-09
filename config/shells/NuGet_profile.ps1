Set-Alias am Add-Migration
Set-Alias ad Add-Migration

Set-Alias em Enable-Migrations
Set-Alias ip Install-Package
Set-Alias unip Uninstall-Package
Set-Alias ud Update-Database

function Update-DatabaseVerbosely {
	Update-Database -Verbose
}
Set-Alias udv Update-DatabaseVerbosely