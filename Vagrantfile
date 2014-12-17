# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # vagrant box add ubuntu/trusty64
  boxes = JSON.parse( File.read 'hosts.json')
  boxes.each do |boxconf|
	  config.vm.define boxconf['name'] do |n|
	    n.vm.box = boxconf['box']
		  n.vm.hostname = boxconf['name']
		  n.vm.network 'private_network', ip: boxconf['ip']
	    n.vm.provider "virtualbox" do |v|
	      v.memory = 512
	      v.cpus = 2
	    end
    end
  end
end
