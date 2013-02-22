vagrant-lamp
============

Base LAMP (box precise64 +  PhpMyAdmin + Symfony 2)

Vagrantfile :
*   Change "config.vm.host_name" value with your project uri "example.local"
*   Change "config.vm.network" with a ip project

/manifests/site.pp
*   Remplace all with your own values (hostname similary "config.vm.host_name" in Vagrantfile)

Add ip project in your host file
*	192.168.33.10 example.local

If you use nfs : 
*	Add in /etc/hosts.allow :
	*	portmap: 127.0.0.1, 192.168.33.0/255.255.255.0
	*	lockd: 127.0.0.1, 192.168.33.0/255.255.255.0
	*	rquotad: 127.0.0.1, 192.168.33.0/255.255.255.0
	*	mountd: 127.0.0.1, 192.168.33.0/255.255.255.0
	*	statd: 127.0.0.1, 192.168.33.0/255.255.255.0
*	Disable firewall

Run virtual machine with : vagrant up

Finally go on [http://example.local/app_dev.php](http://example.local/app_dev.php)