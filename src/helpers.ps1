function ConvertFrom-JsonFile($file) {
	Get-Content $file | Out-String | ConvertFrom-Json
}

function Get-JsonObjectKeys($node) {
	return ($node | Get-Member -MemberType *Property).Name
}

function Check-Command($commandName) {
	return Get-Command $commandName -errorAction SilentlyContinue
}