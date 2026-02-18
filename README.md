Configure You Windows
=====================

**ARCHIVED**: This worked but it was not awesome. Check out [Perch](https://github.com/Laoujin/Perch)!



**Dotfiles for Windows**  

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

- [How to install from a Github Gist](https://boxstarter.org/learn/weblauncher)
- [Example Gist](https://gist.github.com/Laoujin/12f5d2f76d51ee6c0a49)

```ps1
Set-ExecutionPolicy Unrestricted
. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force
Install-BoxstarterPackage -PackageName https://gist.githubusercontent.com/Laoujin/{raw} -DisableReboots
```

Other dotfiles
==============

- [jayharris/dotfiles-windows](https://github.com/jayharris/dotfiles-windows)  
