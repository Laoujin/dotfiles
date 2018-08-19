function Vagrant-Up {
	vagrant up
}
function Vagrant-Status {
	vagrant status
}
function Vagrant-Destroy {
	vagrant destroy -f
}
function Vagrant-Halt {
	vagrant halt
}

Set-Alias vgrt vagrant
Set-Alias vgrtu Vagrant-Up
Set-Alias vgrts Vagrant-Status
Set-Alias vgrtd Vagrant-Destroy
Set-Alias vgrth Vagrant-Halt
