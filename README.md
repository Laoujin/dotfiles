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

Manual Actions
==============
Chrome: Set AdBlock Filters: `###hot-network-questions`



--> Need to sync: ConEmu (is git assumed)

BIG TODOs:

Check which files are assumed unchanged locally in dotfiles
 
è “The system cannot find the path specified” à Provide context: which link were we trying to create
è Check if the file, if it already exists, is really a symlink à if not: rename existing and create link + inform user
è domain.json: Allow “force of program x“
è Allow for specific home directory (c:\users\Wouter.Schandevijl)
è Put HeidiSql in the config but put them in .gitignore
o   Send HeidiSql & FileZilla stuff to work
è bootstrap args: call with only executing a certain program
è add some config to turn off certain Modules (ie: Update-NodePackages, takes too long to complete)
 
More globally:
·        Split config from source
·        Start with tests…
·        Different code for Execution and Reporting
