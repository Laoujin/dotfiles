function ConvertFrom-JsonFile($file) {
	Get-Content $file | Out-String | ConvertFrom-Json
}

function Check-Command($commandName) {
	return Get-Command $commandName -errorAction SilentlyContinue
}