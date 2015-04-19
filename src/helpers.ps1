function ConvertFrom-JsonFile($file) {
	Get-Content $file | Out-String | ConvertFrom-Json
}

function Get-JsonObjectKeys($node) {
	$keys = ($node | Get-Member -MemberType *Property).Name
	[Array]::Reverse($keys)
	return $keys
}

function Check-Command($commandName) {
	return Get-Command $commandName -errorAction SilentlyContinue
}