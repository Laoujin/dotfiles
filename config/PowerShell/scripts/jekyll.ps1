function Start-Jekyll {
	bundle exec jekyll serve --incremental
}
function Start-JekyllWithDrafts {
	bundle exec jekyll serve --drafts --incremental
}
function Start-JekyllDev {
	bundle exec jekyll serve --incremental --config _config_dev.yml
}
function Start-JekyllDevWithDrafts {
	bundle exec jekyll serve --drafts --incremental --config _config_dev.yml
}

Set-Alias bejs Start-Jekyll
Set-Alias bejsd Start-JekyllWithDrafts
Set-Alias bejsdev Start-JekyllDev
Set-Alias bejsddev Start-JekyllDevWithDrafts
