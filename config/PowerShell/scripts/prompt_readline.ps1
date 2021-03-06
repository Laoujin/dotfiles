# Sample Profile
# https://github.com/lzybkr/PSReadLine/blob/master/PSReadLine/SamplePSReadlineProfile.ps1

# TODO: Default shortcuts:
# https://github.com/lzybkr/PSReadLine/blob/master/PSReadLine/en-US/about_PSReadline.help.txt
# [Microsoft.PowerShell.PSConsoleReadLine]::GetKeyHandlers($true, $false)

# Install-Module PSReadLine -RequiredVersion 2.0.0-beta2 -AllowPrerelease
# (Get-Module PSReadLine).Version

# TODO: Setting ErrorColors is broken in 1.2
# But installing 2.0.0-beta2 fails initialization...
# https://github.com/lzybkr/PSReadLine/issues/614

# Try again with final release?
# https://www.powershellgallery.com/packages/PSReadLine
# https://github.com/lzybkr/PSReadLine/releases

# Change colors
# $options = Get-PSReadlineOption
# $options.ErrorForegroundColor = "Green"
# $options.ErrorBackgroundColor = "Red"

if ($host.Name -ne 'ConsoleHost') {
	return
}

# https://rkeithhill.wordpress.com/2013/10/18/psreadline-a-better-line-editing-experience-for-the-powershell-console/
# https://github.com/lzybkr/PSReadLine
Import-Module PSReadline

# To enable bash style completion without using Emacs mode, you can use:
#Set-PSReadLineOption -EditMode Emacs

#Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key 'UpArrow' -Function 'HistorySearchBackward'
Set-PSReadlineKeyHandler -Key 'DownArrow' -Function 'HistorySearchForward'

Set-PSReadlineKeyHandler -Key 'Ctrl+^' -Function 'GotoBrace'

# TODO: Yanking... Probably better to just switch to Emacs mode...

# More interesting Functions:
# AcceptLine               (Cmd: <Enter>              Emacs: <Enter> or <Ctrl+M>)

#         Attempt to execute the current input.  If the current input is incomplete (for
#         example there is a missing closing parenthesis, bracket, or quote, then the
#         continuation prompt is displayed on the next line and PSReadline waits for
#         keys to edit the current input.

#     AcceptAndGetNext         (Cmd: unbound              Emacs: <Ctrl+O>)

#         Like AcceptLine, but after the line completes, start editing the next line
#         from history.

#     ValidateAndAcceptLine    (Cmd: unbound              Emacs: unbound)

#         Like AcceptLine but performs additional validation including:

#             * Check for additional parse errors
#             * Validate command names are all found
#             * If using PowerShell V4 or greater, validate the parameters and arguments

#         If there are any errors, the error message is displayed and not accepted nor added
#         to the history unless you either correct the command line or execute AcceptLine or
#         ValidateAndAcceptLine again while the error message is displayed.



# This key handler shows the entire or filtered history using Out-GridView. The
# typed text is used as the substring pattern for filtering. A selected command
# is inserted to the command line without invoking. Multiple command selection
# is supported, e.g. selected by Ctrl + Click.
Set-PSReadlineKeyHandler -Key F7 `
								 -BriefDescription History `
								 -LongDescription 'Show command history' `
								 -ScriptBlock {
	$pattern = $null
	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$pattern, [ref]$null)
	if ($pattern) {
		$pattern = [regex]::Escape($pattern)
	}

	$history = [System.Collections.ArrayList]@(
		$last = ''
		$lines = ''
		foreach ($line in [System.IO.File]::ReadLines((Get-PSReadlineOption).HistorySavePath)) {
			if ($line.EndsWith('`')) {
				$line = $line.Substring(0, $line.Length - 1)
				$lines = if ($lines) { "$lines`n$line" } else { $line }
				continue
			}

			if ($lines) {
				$line = "$lines`n$line"
				$lines = ''
			}

			if (($line -cne $last) -and (!$pattern -or ($line -match $pattern))) {
				$last = $line
				$line
			}
		}
	)
	$history.Reverse()

	$command = $history | Out-GridView -Title History -PassThru
	if ($command) {
		[Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
		[Microsoft.PowerShell.PSConsoleReadLine]::Insert(($command -join "`n"))
	}
}




# Ctrl+Shift+j to mark the current directory
# Ctrl+j will change back to that directory
$global:PSReadlineMarkedDir = $false

Set-PSReadlineKeyHandler -Key "Ctrl+Shift+j" `
								 -BriefDescription MarkDirectory `
								 -LongDescription "Mark the current directory" `
								 -ScriptBlock {
	param($key, $arg)

	$global:PSReadlineMarkedDir = $pwd
}

Set-PSReadlineKeyHandler -Key "Ctrl+j" `
								 -BriefDescription JumpDirectory `
								 -LongDescription "Goto the marked directory" `
								 -ScriptBlock {
	param($key, $arg)

	if ($global:PSReadlineMarkedDir) {
		cd $global:PSReadlineMarkedDir
		[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
		# TODO: Wrong cursor placement :(
	}
}




Set-PSReadlineKeyHandler -Key Alt+w `
								 -BriefDescription SaveInHistory `
								 -LongDescription "Save current line in history but do not execute" `
								 -ScriptBlock {
	param($key, $arg)

	$line = $null
	$cursor = $null
	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
	[Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
	[Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
}



Set-PSReadlineKeyHandler -Key '"',"'" `
                         -BriefDescription SmartInsertQuote `
                         -LongDescription "Insert paired quotes if not already on a quote" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    $quotesAmount = (Select-String -InputObject $line -Pattern $key.KeyChar -AllMatches).Matches.Count
    if ($quotesAmount % 2 -eq 1) {
        # Oneven amount of quotes, put just one quote
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($key.KeyChar)
    }
    elseif ($line[$cursor] -eq $key.KeyChar) {
        # Just move the cursor
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
    else {
        $otherQuote = if ($key.KeyChar -eq "'") {'"'} Else {"'"}
        $lineBeforeCursor = $line.Substring(0, $cursor)
        $quotesBeforeAmount = (Select-String -InputObject $lineBeforeCursor -Pattern $otherQuote -AllMatches).Matches.Count
        $lineAfterCursor = $line.Substring($cursor)
        $quotesAfterAmount = (Select-String -InputObject $lineAfterCursor -Pattern $otherQuote -AllMatches).Matches.Count

        if ($quotesBeforeAmount % 2 -eq 1 -and $quotesAfterAmount % 2 -eq 1) {
            # Insert one quote if inside the other quotes
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($key.KeyChar)
        }
        else {
            # Insert matching quotes, move cursor to be in between the quotes
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)" * 2)
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
        }
    }
}

# cmder: Rename current tab based on current directory
Set-PSReadlineKeyHandler -Key Alt+r `
								 -BriefDescription RenameTabToDir `
								 -LongDescription "Rename the current Cmder tab to the directory name" `
								 -ScriptBlock {
	param($key, $arg)

	[Microsoft.PowerShell.PSConsoleReadline]::Insert("RenameTab '" + (Get-Item -Path ".\" -Verbose).Name + "'")
	[Microsoft.PowerShell.PSConsoleReadLine]::ValidateAndAcceptLine()
}
Set-PSReadlineKeyHandler -Key Ctrl+Alt+r `
								 -BriefDescription RenameTabToTwoDirs `
								 -LongDescription "Rename the current Cmder tab to the parent directory name dash directory name" `
								 -ScriptBlock {
	param($key, $arg)

	$currentDir = (Get-Item -Path ".\" -Verbose)
	[Microsoft.PowerShell.PSConsoleReadline]::Insert("RenameTab '" + $currentDir.Parent.Name + "-" + $currentDir.Name + "'")
	[Microsoft.PowerShell.PSConsoleReadLine]::ValidateAndAcceptLine()
}

# Set-PSReadlineKeyHandler -Chord Ctrl+\ `
#                          -BriefDescription SearchForwardPipeChar `
#                          -Description &quot;Searches forward for the next pipeline character&quot; `
#                          -ScriptBlock {
#     param($key, $arg)
#     [Microsoft.PowerShell.PSConsoleReadLine]::CharacterSearch($key, '|')
# }
# Set-PSReadlineKeyHandler -Chord Ctrl+Shift+\ `
#                          -BriefDescription SearchBackwardPipeChar `
#                          -Description &quot;Searches backward for the next pipeline character&quot; `
#                          -ScriptBlock {
#     param($key, $arg)
#     [Microsoft.PowerShell.PSConsoleReadLine]::CharacterSearchBackward($key, '|')
# }


# Set-PSReadlineKeyHandler -Key '(','{','[' `
# 								 -BriefDescription InsertPairedBraces `
# 								 -LongDescription "Insert matching braces" `
# 								 -ScriptBlock {
# 	param($key, $arg)

# 	$closeChar = switch ($key.KeyChar) {
# 		<#case#> '(' { [char]')'; break }
# 		<#case#> '{' { [char]'}'; break }
# 		<#case#> '[' { [char]']'; break }
# 	}

# 	[Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)$closeChar")
# 	$line = $null
# 	$cursor = $null
# 	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
# 	[Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
# }

# Set-PSReadlineKeyHandler -Key ')',']','}' `
# 								 -BriefDescription SmartCloseBraces `
# 								 -LongDescription "Insert closing brace or skip" `
# 								 -ScriptBlock {
# 	param($key, $arg)

# 	$line = $null
# 	$cursor = $null
# 	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

# 	if ($line[$cursor] -eq $key.KeyChar) {
# 		[Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
# 	} else {
# 		[Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)")
# 	}
# }

# Set-PSReadlineKeyHandler -Key Backspace `
# 								 -BriefDescription SmartBackspace `
# 								 -LongDescription "Delete previous character or matching quotes/parens/braces" `
# 								 -ScriptBlock {
# 	param($key, $arg)

# 	$line = $null
# 	$cursor = $null
# 	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

# 	if ($cursor -gt 0) {
# 		$toMatch = $null
# 		switch ($line[$cursor]) {
# 			<#case#> '"' { $toMatch = '"'; break }
# 			<#case#> "'" { $toMatch = "'"; break }
# 			<#case#> ')' { $toMatch = '('; break }
# 			<#case#> ']' { $toMatch = '['; break }
# 			<#case#> '}' { $toMatch = '{'; break }
# 		}

# 		if ($toMatch -ne $null -and $line[$cursor-1] -eq $toMatch) {
# 			[Microsoft.PowerShell.PSConsoleReadLine]::Delete($cursor - 1, 2)
# 		} else {
# 			[Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteChar($key, $arg)
# 		}
# 	}
# }

# #endregion Smart Insert/Delete

# # Sometimes you enter a command but realize you forgot to do something else first.
# # This binding will let you save that command in the history so you can recall it,
# # but it doesn't actually execute.  It also clears the line with RevertLine so the
# # undo stack is reset - though redo will still reconstruct the command line.
# Set-PSReadlineKeyHandler -Key Alt+w `
# 								 -BriefDescription SaveInHistory `
# 								 -LongDescription "Save current line in history but do not execute" `
# 								 -ScriptBlock {
# 	param($key, $arg)

# 	$line = $null
# 	$cursor = $null
# 	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
# 	[Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
# 	[Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
# }

# # Sometimes you want to get a property of invoke a member on what you've entered so far
# # but you need parens to do that.  This binding will help by putting parens around the current selection,
# # or if nothing is selected, the whole line.
# Set-PSReadlineKeyHandler -Key 'Alt+(' `
# 						 -BriefDescription ParenthesizeSelection `
# 						 -LongDescription "Put parenthesis around the selection or entire line and move the cursor to after the closing parenthesis" `
# 						 -ScriptBlock {
# 	param($key, $arg)

# 	$selectionStart = $null
# 	$selectionLength = $null
# 	[Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

# 	$line = $null
# 	$cursor = $null
# 	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
# 	if ($selectionStart -ne -1) {
# 		[Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, '(' + $line.SubString($selectionStart, $selectionLength) + ')')
# 		[Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
# 	} else {
# 		[Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, '(' + $line + ')')
# 		[Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
# 	}
# }



# # This example will replace any aliases on the command line with the resolved commands.
# Set-PSReadlineKeyHandler -Key "Alt+%" `
# 								 -BriefDescription ExpandAliases `
# 								 -LongDescription "Replace all aliases with the full command" `
# 								 -ScriptBlock {
# 	param($key, $arg)

# 	$ast = $null
# 	$tokens = $null
# 	$errors = $null
# 	$cursor = $null
# 	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

# 	$startAdjustment = 0
# 	foreach ($token in $tokens) {
# 		if ($token.TokenFlags -band [System.Management.Automation.Language.TokenFlags]::CommandName) {
# 			$alias = $ExecutionContext.InvokeCommand.GetCommand($token.Extent.Text, 'Alias')
# 			if ($alias -ne $null) {
# 				$resolvedCommand = $alias.ResolvedCommandName
# 				if ($resolvedCommand -ne $null) {
# 					$extent = $token.Extent
# 					$length = $extent.EndOffset - $extent.StartOffset
# 					[Microsoft.PowerShell.PSConsoleReadLine]::Replace(
# 						$extent.StartOffset + $startAdjustment,
# 						$length,
# 						$resolvedCommand)

# 					# Our copy of the tokens won't have been updated, so we need to
# 					# adjust by the difference in length
# 					$startAdjustment += ($resolvedCommand.Length - $length)
# 				}
# 			}
# 		}
# 	}
# }

# # F1 for help on the command line - naturally
# Set-PSReadlineKeyHandler -Key F1 `
# 								 -BriefDescription CommandHelp `
# 								 -LongDescription "Open the help window for the current command" `
# 								 -ScriptBlock {
# 	param($key, $arg)

# 	$ast = $null
# 	$tokens = $null
# 	$errors = $null
# 	$cursor = $null
# 	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

# 	$commandAst = $ast.FindAll( {
# 		$node = $args[0]
# 		$node -is [System.Management.Automation.Language.CommandAst] -and
# 			$node.Extent.StartOffset -le $cursor -and
# 			$node.Extent.EndOffset -ge $cursor
# 		}, $true) | Select-Object -Last 1

# 	if ($commandAst -ne $null) {
# 		$commandName = $commandAst.GetCommandName()
# 		if ($commandName -ne $null) {
# 			$command = $ExecutionContext.InvokeCommand.GetCommand($commandName, 'All')
# 			if ($command -is [System.Management.Automation.AliasInfo]) {
# 				$commandName = $command.ResolvedCommandName
# 			}

# 			if ($commandName -ne $null) {
# 				Get-Help $commandName -ShowWindow
# 			}
# 		}
# 	}
# }
