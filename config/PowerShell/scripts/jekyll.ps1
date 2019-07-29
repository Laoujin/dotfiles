function Start-Jekyll {
	# TODO: Incremental does not reload on _data changes
	# TODO: --incremental
	bundle exec jekyll serve
}
function Start-JekyllWithDrafts {
	bundle exec jekyll serve --drafts --incremental
}

Set-Alias bejs Start-Jekyll
Set-Alias bejsd Start-JekyllWithDrafts
