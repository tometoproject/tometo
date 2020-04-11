Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu1804"
  config.vm.synced_folder ".", "/home/vagrant/tometo"
  config.vm.synced_folder ".", "/vagrant"
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "/home/vagrant/tometo/site.yml"
  end
  config.vm.network "forwarded_port", guest: 4001, host: 4001
  config.vm.network "forwarded_port", guest: 1234, host: 1234
  config.vm.network "forwarded_port", guest: 4040, host: 4040
  config.vm.provider "virtualbox" do |v|
    v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end
end
