# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.host_name = "YOUR_URI_PROJECT"
  config.vm.network :hostonly, "192.168.33.10"
  config.vm.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  config.vm.share_folder("v-root", "/vagrant", ".", {:nfs => true, :nfs_version => "3"})

  config.vm.provision :puppet do |puppet|
  puppet.manifests_path = "./manifests"
  puppet.module_path = "./modules"
    puppet.manifest_file  = "site.pp"
    puppet.options = "--verbose"
  end

end
