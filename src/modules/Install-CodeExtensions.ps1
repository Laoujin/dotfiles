function Install-CodeExtensions($packages) {
    Write-Host "Install-CodeExtensions"

    # https://code.visualstudio.com/docs/editor/command-line
    # C:\Users\%USERNAME%\AppData\Local\Programs\Microsoft VS Code\bin

    $path = "C:\Users\$($env:USERNAME)\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd"
	foreach ($package in $packages) {
		& $path --install-extension $package
    }
}
