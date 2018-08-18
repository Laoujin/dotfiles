TODO
====

Desired State configuration  
https://gallery.technet.microsoft.com/scriptcenter/DSC-Resource-Kit-All-c449312d




WIP
---

Check out: https://github.com/jayharris/dotfiles-windows


### Code

Says "Symlink already exists" while it should: rename the existing file, create symlink  
ie: check if symlink already exists or that destination file already exists  
“The system cannot find the path specified” à Provide context: which link were we trying to create  
Check if the file, if it already exists, is really a symlink à if not: rename existing and create link + inform user  

- bootstrap args: call with only executing a certain program
- add some config to turn off certain Modules (ie: Update-NodePackages, takes too long to complete)
- Split config from source
- dotfiles: ShellContextMenu's
- Allow recursive symlinking
- Symlink .theme did not work if the containing folder did not exist




bootstrap failures on:
- it said cmder xml ok but didn't replace?
- copying PowerShell: directory didn't exist and failed...
