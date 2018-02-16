# Load posh-git module from current directory
#Import-Module .\posh-git

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
Import-Module Posh-Git

# Set up a simple prompt, adding the git prompt parts inside git repos
# TODO: no longer needed with latest PS5 and PoshGit?
#function global:prompt {
#	$realLASTEXITCODE = $LASTEXITCODE
#
#	# Reset color, which can be messed up by Enable-GitColors
#	$Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor
#
#	Write-Host("`n$($pwd.ProviderPath)") -nonewline -ForegroundColor blue
#
#	Write-VcsStatus
#
#	$global:LASTEXITCODE = $realLASTEXITCODE
#	return "> "
#}

#Enable-GitColors

# Change colors
$global:GitPromptSettings.WorkingForegroundColor = [ConsoleColor]::Yellow
$global:GitPromptSettings.BranchForegroundColor = [ConsoleColor]::Green



function Pull-FocusId($branchName) {
	if ($branchName.StartsWith("FOCUS-")) {
		return $branchName.Substring(0, "FOCUS-XXXX".Length)
	}
	return "FOCUS-"
}

function Create-PullRequest() {
	$baseUrl = "https://stash.antwerpen.be/projects/FOCUS/repos"
	$targetBranch = "development"
	$reviewers = "reviewers=ex02179"

	$branch = git rev-parse --abbrev-ref HEAD
	git push -u origin $branch
	$repo = (git remote -v)[0]
	$repo = $repo.SubString($repo.LastIndexOf("/") + 1)
	$repo = $repo.Substring(0, $repo.IndexOf("."))
	start "$baseUrl/$repo/pull-requests?create&targetBranch=refs/heads/$targetBranch&sourceBranch=refs/heads/$branch&$reviewers"
}

Set-Alias gt git
Set-Alias gut git
Set-Alias gti git
Set-Alias got git
Set-Alias pr Create-PullRequest