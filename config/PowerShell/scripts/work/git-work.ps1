function Create-PullRequest() {
	$urlTemplate += "{base-url}/pullrequestcreate?sourceRef={source-branch}&targetRef={target-branch}"

	$baseUrl = git remote get-url origin
	$sourceBranch = git rev-parse --abbrev-ref HEAD
	$targetBranch = "develop"

	git push -u origin $sourceBranch
	start $urlTemplate.Replace("{base-url}", $baseUrl).Replace("{source-branch}", [uri]::EscapeDataString($sourceBranch)).Replace("{target-branch}", $targetBranch)
}

Set-Alias pr Create-PullRequest
