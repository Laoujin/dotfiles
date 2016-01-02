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