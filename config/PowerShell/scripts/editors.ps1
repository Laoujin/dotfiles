$editor = "C:\Program Files\Notepad++\notepad++.exe"
$ide = "C:\Users\$($env:username)\AppData\Local\Programs\Microsoft VS Code\bin\Code.cmd"
$ide2 = "C:\Program Files\Microsoft VS Code\bin\Code.cmd"
$markdownEditor = "C:\Program Files (x86)\MarkdownPad 2\MarkdownPad2.exe"


function Edit-Hosts {
	Start-Process $editor $env:windir\system32\drivers\etc\hosts
}


function Edit-Profile {
	Start-Process $editor $profile
}


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
