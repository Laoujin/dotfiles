function Install-CodeExtensions($packages) {
    Write-Host "Install-CodeExtensions"

    # https://code.visualstudio.com/docs/editor/command-line
    # C:\Users\%USERNAME%\AppData\Local\Programs\Microsoft VS Code\bin

    $path = "C:\Users\$($env:USERNAME)\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd"
    if (-not (Test-Path $path)) {
        $path = "C:\Program Files\Microsoft VS Code\bin\Code.cmd"
    }

    # $proxies = (Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings').proxyServer
    # & $path --proxy-server=http://10.0.25.16:8080

	foreach ($package in $packages) {
        & $path --install-extension $package
    }
}
