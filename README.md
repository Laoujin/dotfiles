Configure You Windows
=====================
**Dotfiles for Windows 8.1.**  
  
Automatically install software and keep their settings synchronized.     
Configure Windows Explorer, link your important files to cloud folders, setup .gitconfig, .bashrc and PowerShell $profile, install modules for your package managers. 

**Step 1:**   
Install your software with [Boxstarter](http://boxstarter.org/).

**Step 2:**  
Configure `bootstrap.json` files.

**Step 3:**  
Run `.\bootstrap.ps1` from an Administrator PowerShell.

Boxstarter
==========

```
iex ((New-Object System.Net.WebClient).DownloadString('http://boxstarter.org/bootstrapper.ps1')); get-boxstarter -Force

Install-BoxstarterPackage -PackageName https://gist.githubusercontent.com/Laoujin/{raw} -DisableReboots
```
