$editor = "C:\Program Files\Notepad++\notepad++.exe"
$ide_subl = "C:\Program Files\Sublime Text 3\sublime_text.exe"
$ide = "C:\Users\$($env:username)\AppData\Local\Programs\Microsoft VS Code\bin\Code.cmd"
$markdownEditor = "C:\Program Files (x86)\MarkdownPad 2\MarkdownPad2.exe"


function Edit-Hosts {
	START $editor $env:windir\system32\drivers\etc\hosts
}


function Edit-Profile {
	START $editor $profile
}


function Start-SublimeText {
	if ($args.length -eq 0 -or $args[0] -eq $null) {
		START $ide_subl
		return
	}

	# Fix for GitGutter not working when starting ST3 from the commandline
	START $ide_subl $args
}
Set-Alias subl Start-VSCode


Set-Alias mdp $markdownEditor


# https://code.visualstudio.com/docs/editor/command-line

function Start-VSCode {
	if ($args.length -eq 0 -or $args[0] -eq $null) {
		START $ide --new-window
		return
	}

	# Should probably not use START for VSCode

	START $ide "--new-window $args"
}
Set-Alias cde Start-VSCode
