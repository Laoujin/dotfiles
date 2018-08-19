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


# TODO: Change this for RD:

# function Pull-FocusId($branchName) {
# 	if ($branchName.StartsWith("FOCUS-")) {
# 		return $branchName.Substring(0, "FOCUS-XXXX".Length)
# 	}
# 	return "FOCUS-"
# }

# function Create-PullRequest() {
# 	$baseUrl = "https://stash.antwerpen.be/projects/FOCUS/repos"
# 	$targetBranch = "development"
# 	$reviewers = "reviewers=ex02179"

# 	$branch = git rev-parse --abbrev-ref HEAD
# 	git push -u origin $branch
# 	$repo = (git remote -v)[0]
# 	$repo = $repo.SubString($repo.LastIndexOf("/") + 1)
# 	$repo = $repo.Substring(0, $repo.IndexOf("."))
# 	start "$baseUrl/$repo/pull-requests?create&targetBranch=refs/heads/$targetBranch&sourceBranch=refs/heads/$branch&$reviewers"
# }

# Set-Alias pr Create-PullRequest
