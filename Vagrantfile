# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
    config.vm.box = "CentOS-6.4-x86_64-minimal"
#    config.vm.box_url = "https://dl.dropbox.com/u/7225008/Vagrant/CentOS-6.3-x86_64-minimal.box"
    config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box"
    config.vm.host_name = "my-dev"
    config.vm.network :hostonly, "192.168.3.10"
    config.vm.share_folder "puppet-files", "/etc/puppet/files", "./files"
    #copy sshkey+gitconfig+git alias
    config.vm.provision :shell, :inline => "echo -e '#{File.read("#{Dir.home}/.ssh/id_rsa")}' > '/home/vagrant/.ssh/id_rsa'"
    config.vm.provision :shell, :inline => "echo -e '#{File.read("#{Dir.home}/.gitconfig")}' > '/home/vagrant/.gitconfig'"
    config.vm.provision :shell, :inline => "alias gl=\"git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit\""
    config.vm.provision :shell, :inline => "alias lg='git log --graph --full-history --all --color --pretty=format:\"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s\"'"
    #get rid of iptables 
    config.vm.provision :shell, :inline => "sudo service iptables stop;sudo chkconfig iptables off"
    #run puppet to setup ES+add some packages + add git repo
    config.vm.provision :puppet do |puppet|
    puppet.module_path = "./modules"
    puppet.manifests_path = "./manifests"
    puppet.manifest_file = "init.pp"
    puppet.facter = { "fqdn" => "example.com", "hostname" => "my-dev" }
    #puppet.options = ["--fileserverconfig=/vagrant/fileserver.conf", "--verbose", "--debug","--pluginsync" ]
    puppet.options = ["--fileserverconfig=/vagrant/fileserver.conf", "--verbose", "--pluginsync"]

    #load sample in ES
    config.vm.provision :shell, :inline => "cd python-libnessus;sudo python setup.py install;cd examples/;python es.py"
    #add a pre commit hook to libnessus repo, to validate the pep8/pyflake
    config.vm.provision :shell, :inline => "cd python-libnessus;ln -s pep8-pyflakes-pre-commit.sh .git/hooks/pre-commit"
  end
end
