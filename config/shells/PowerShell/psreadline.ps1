if ($host.Name -eq 'ConsoleHost') {
	# https://rkeithhill.wordpress.com/2013/10/18/psreadline-a-better-line-editing-experience-for-the-powershell-console/
	# https://github.com/lzybkr/PSReadLine
	Import-Module PSReadline

	Set-PSReadlineKeyHandler -Key 'UpArrow' -Function 'HistorySearchBackward'
	Set-PSReadlineKeyHandler -Key 'DownArrow' -Function 'HistorySearchForward'
}