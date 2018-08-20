Set-Alias urd Update-RezinalDatabases

function Update-RezinalDatabases {
	Update-Database -Project Rezinal.Erp.Migrations -Context MigrationsContext
	Update-Database -Project Bromo.Logbook.Migrations -Context LogbookContext
	Update-Database -Project Bromo.StorageService.Migrations -Context StorageServiceContext
}



Set-Alias ubd Update-BasfCleaningDatabases

function Update-BasfCleaningDatabases {
	Update-Database -Project Basf.Cleaning.Migrations -Context MigrationsContext
	Update-Database -Project Basf.Cleaning.Comments.Migrations -Context CommentsContext
	Update-Database -Project Basf.Cleaning.StorageService.Migrations -Context StorageServiceContext
}
