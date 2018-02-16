function Start-SublimeText {
	if ($args.length -eq 0 -or $args[0] -eq $null) {
		START "C:\Program Files\Sublime Text 3\sublime_text.exe"
	}

	# Fix for GitGutter not working when starting ST3 from the commandline
	START "C:\Program Files\Sublime Text 3\sublime_text.exe" $args
}
Set-Alias subl Start-SublimeText


Set-Alias mdp "C:\Program Files (x86)\MarkdownPad 2\MarkdownPad2.exe"


function Start-Jekyll {
	bundle exec jekyll serve
}
function Start-JekyllWithDrafts {
	bundle exec jekyll serve --drafts
}

Set-Alias bejs Start-Jekyll
Set-Alias bejsd Start-JekyllWithDrafts


function Vagrant-Up {
	vagrant up
}
function Vagrant-Status {
	vagrant status
}
function Vagrant-Destroy {
	vagrant destroy -f
}
function Vagrant-Halt {
	vagrant halt
}

Set-Alias vgrt vagrant
Set-Alias vgrtu Vagrant-Up
Set-Alias vgrts Vagrant-Status
Set-Alias vgrtd Vagrant-Destroy
Set-Alias vgrth Vagrant-Halt