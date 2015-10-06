# h = Get-History


if ($host.Name -eq 'ConsoleHost') {
	# https://rkeithhill.wordpress.com/2013/10/18/psreadline-a-better-line-editing-experience-for-the-powershell-console/
	# https://github.com/lzybkr/PSReadLine
	Import-Module PSReadline

	# To enable bash style completion without using Emacs mode, you can use:
	#Set-PSReadLineOption -HistorySearchCursorMovesToEnd 
	#Set-PSReadLineOption -EditMode Emacs

	Set-PSReadlineKeyHandler -Key 'UpArrow' -Function 'HistorySearchBackward'
	Set-PSReadlineKeyHandler -Key 'DownArrow' -Function 'HistorySearchForward'

	# https://github.com/lzybkr/PSReadLine/blob/master/PSReadLine/SamplePSReadlineProfile.ps1

	Set-PSReadlineKeyHandler -Key '"',"'" `
									 -BriefDescription SmartInsertQuote `
									 -LongDescription "Insert paired quotes if not already on a quote" `
									 -ScriptBlock {
		param($key, $arg)

		$line = $null
		$cursor = $null
		[PSConsoleUtilities.PSConsoleReadline]::GetBufferState([ref]$line, [ref]$cursor)

		if ($line[$cursor] -eq $key.KeyChar) {
			# Just move the cursor
			[PSConsoleUtilities.PSConsoleReadline]::SetCursorPosition($cursor + 1)
		}
		else {
			# Insert matching quotes, move cursor to be in between the quotes
			[PSConsoleUtilities.PSConsoleReadline]::Insert("$($key.KeyChar)" * 2)
			[PSConsoleUtilities.PSConsoleReadline]::GetBufferState([ref]$line, [ref]$cursor)
			[PSConsoleUtilities.PSConsoleReadline]::SetCursorPosition($cursor - 1)
		}
	}
}