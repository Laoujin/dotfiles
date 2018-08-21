Import-Module Posh-Git


# Change colors
#Enable-GitColors
$global:GitPromptSettings.WorkingForegroundColor = [ConsoleColor]::Yellow
$global:GitPromptSettings.BranchForegroundColor = [ConsoleColor]::Green



# I can't type
Set-Alias gt git
Set-Alias gut git
Set-Alias gti git
Set-Alias got git
Set-Alias guit git
Set-Alias giut git
