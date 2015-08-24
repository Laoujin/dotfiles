# Instead of aliases:
# Original: https://github.com/joelthelion/autojump (experimental CLink support)
# PS Specific: https://github.com/tkellogg/Jump-Location
# z is the new j, yo: https://github.com/rupa/z
# z PS: https://github.com/vincpa/z

# Download stuff:
# https://github.com/chaliy/psurl/

# Use TFS from CLI:
# https://bitbucket.org/Sumo/tfdash/overview

# PSCX source: (download source, has some interesting functions)
# http://pscx.codeplex.com/
# See also: C:\Program Files (x86)\PowerShell Community Extensions\Pscx3\Pscx

# PSReadLine
if ($host.Name -eq 'ConsoleHost') {
	# https://rkeithhill.wordpress.com/2013/10/18/psreadline-a-better-line-editing-experience-for-the-powershell-console/
	# https://github.com/lzybkr/PSReadLine
	Import-Module PSReadline

	Set-PSReadlineKeyHandler -Key 'UpArrow' -Function 'HistorySearchBackward'
	Set-PSReadlineKeyHandler -Key 'DownArrow' -Function 'HistorySearchForward'

	# Updating?
	# cmd.exe
	# powershell -noprofile
	# Update-Module PSReadLine
}

Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

. ".\Microsoft.PowerShell_functions.ps1"

if (Test-Path ".\Microsoft.PowerShell_aliases.ps1") {
	. ".\Microsoft.PowerShell_aliases.ps1"
}

Append-EnvPath "C:\Program Files\Sublime Text 3"
Append-EnvPath "C:\Program Files (x86)\MarkdownPad 2"

Set-Alias vgrt vagrant
Set-Alias mkd CreateAndSet-Directory
Set-Alias fs Get-DiskUsage

# Easier Navigation: .., ..., ...., ....., and ~
${function:~} = { Set-Location ~ }
# PoSh won't allow ${function:..} because of an invalid path error, so...
${function:Set-ParentLocation} = { Set-Location .. }; Set-Alias ".." Set-ParentLocation
${function:...} = { Set-Location ..\.. }
${function:....} = { Set-Location ..\..\.. }
${function:.....} = { Set-Location ..\..\..\.. }
${function:......} = { Set-Location ..\..\..\..\.. }

# Load posh-git module from current directory
#Import-Module .\posh-git

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
Import-Module Posh-Git

# Set up a simple prompt, adding the git prompt parts inside git repos
function global:prompt {
	$realLASTEXITCODE = $LASTEXITCODE

	# Reset color, which can be messed up by Enable-GitColors
	$Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

	Write-Host("`n$($pwd.ProviderPath)") -nonewline -ForegroundColor blue

	Write-VcsStatus

	$global:LASTEXITCODE = $realLASTEXITCODE
	return "> "
}

Enable-GitColors

Pop-Location

Start-SshAgent -Quiet

# Change colors
$global:GitPromptSettings.WorkingForegroundColor = [ConsoleColor]::Yellow
$global:GitPromptSettings.UntrackedForegroundColor = [ConsoleColor]::Yellow
$global:GitPromptSettings.BranchForegroundColor = [ConsoleColor]::Green

$hostColors = (Get-Host).PrivateData
$hostColors.ErrorForegroundColor = "DarkMagenta"
#$Host.UI.RawUI.ForegroundColor = 