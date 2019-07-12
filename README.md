Configure You Windows
=====================

**Dotfiles for Windows 8.1.**  

Automatically install software and keep their settings synchronized.  
Configure Windows Explorer, link your important files to cloud folders, setup .gitconfig, .bashrc and PowerShell $profile, install modules for your package managers.  

**Step 1:**  
Install your software with [Boxstarter](http://boxstarter.org/).

**Step 2:**  
Configure your stuff in `.\bootstrap` and `.\config`.

**Step 3:**  
Run `.\bootstrap.ps1` from an Administrator PowerShell prompt.

Clone
=====

Started using submodules for parts of dotfiles that can exist on their own.

```powershell
# First time
git submodule update --init --recursive

# Update after first time
git pull --recurse-submodules
```

Boxstarter
==========

```ps1
iex ((New-Object System.Net.WebClient).DownloadString('http://boxstarter.org/bootstrapper.ps1')); get-boxstarter -Force

Install-BoxstarterPackage -PackageName https://gist.githubusercontent.com/Laoujin/{raw} -DisableReboots
```

Other dotfiles
==============

- [jayharris/dotfiles-windows](https://github.com/jayharris/dotfiles-windows)  
