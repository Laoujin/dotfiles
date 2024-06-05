function Create-PullRequest() {
	$baseUrl = git remote get-url origin

	if ($baseUrl -match 'github.com') {
		$urlTemplate += "{base-url}/compare/{target-branch}...{source-branch}"
	} else {
		$urlTemplate += "{base-url}/pullrequestcreate?sourceRef={source-branch}&targetRef={target-branch}"
	}

	$sourceBranch = git rev-parse --abbrev-ref HEAD
	# $targetBranch = "develop"
	$targetBranch = "master"

	git push -u origin $sourceBranch
	start $urlTemplate.Replace("{base-url}", $baseUrl).Replace("{source-branch}", [uri]::EscapeDataString($sourceBranch)).Replace("{target-branch}", $targetBranch)
}

Set-Alias pr Create-PullRequest
