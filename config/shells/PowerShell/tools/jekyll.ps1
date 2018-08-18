function Start-Jekyll {
	bundle exec jekyll serve
}
function Start-JekyllWithDrafts {
	bundle exec jekyll serve --drafts
}

Set-Alias bejs Start-Jekyll
Set-Alias bejsd Start-JekyllWithDrafts
