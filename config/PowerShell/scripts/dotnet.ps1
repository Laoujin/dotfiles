Set-Alias cleanbins Clean-BinFolders

function Clean-BinFolders {
    Get-ChildItem -Recurse -Directory | Where-Object { $_.Name -eq "bin" -or $_.Name -eq "obj" } | ForEach-Object { Write-Host $_.FullName; npx rimraf $_.FullName }
}
