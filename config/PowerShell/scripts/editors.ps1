$editor = "C:\Program Files\Notepad++\notepad++.exe"
$ide_subl = "C:\Program Files\Sublime Text 3\sublime_text.exe"
$ide = "C:\Users\$($env:username)\AppData\Local\Programs\Microsoft VS Code\bin\Code.cmd"
$ide2 = "C:\Program Files\Microsoft VS Code\bin\Code.cmd"
$markdownEditor = "C:\Program Files (x86)\MarkdownPad 2\MarkdownPad2.exe"


function Edit-Hosts {
	Start-Process $editor $env:windir\system32\drivers\etc\hosts
}


function Edit-Profile {
	Start-Process $editor $profile
}


function Start-SublimeText {
	if ($args.length -eq 0 -or $null -eq $args[0]) {
		Start-Process $ide_subl
		return
	}

	# Fix for GitGutter not working when starting ST3 from the commandline
	Start-Process $ide_subl $args
}
Set-Alias subl Start-VSCode


Set-Alias mdp $markdownEditor


# https://code.visualstudio.com/docs/editor/command-line
function Start-VSCode {
	$idePath = $ide
	if (-not (Test-Path $idePath)) {
		$idePath = $ide2
	}

	if ($args.length -eq 0 -or $null -eq $args[0]) {
		& $idePath --reuse-window
		return
	}

	$folder = Resolve-Path $args
	& "$idePath" "$folder"
}
Set-Alias cde Start-VSCode
