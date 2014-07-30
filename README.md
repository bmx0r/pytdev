POC ES+Kibana+libnessus
=======================

Quick setup of a dev env
tested on : 
- Vagrant version 1.2.2
- VirtualBox 4.2.12

git clone https://github.com/bmx0r/pytdev.git

# update the vagrant file to use an IP that is not in conflict with your network
cd pytdev
git submodule init
git submodule update
git submodule foreach git submodule init
git submodule foreach git submodule update
vagrant up
Enjoy...
