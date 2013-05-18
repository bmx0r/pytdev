# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
    config.vm.box = "CentOS-6.3-x86_64-minimal"
    config.vm.box_url = "https://dl.dropbox.com/u/7225008/Vagrant/CentOS-6.3-x86_64-minimal.box"
    config.vm.host_name = "python-dev"
    config.vm.network :hostonly, "192.168.1.10"
    config.vm.share_folder "puppet-files", "/etc/puppet/files", "./files"
    config.vm.forward_port 8000, 8000
  
    config.vm.provision :puppet do |puppet|
    puppet.module_path = "./modules"
    puppet.manifests_path = "./manifests"
    puppet.manifest_file = "init.pp"
    puppet.facter = { "fqdn" => "patinvsvelo.com", "hostname" => "python-dev" }
    puppet.options = ["--fileserverconfig=/vagrant/fileserver.conf", "--verbose", "--debug","--pluginsync" ]
  end
end
