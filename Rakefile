
desc "Bring up vagrant, then run ansible"
task :default => [ :vagrant, :ansible ]

desc "Bring up Vagrant and configure Ansible for vagrant hosts"
task :vagrant => [ 'vagrant:up' ]

desc "Run Ansible"
task :ansible => [ 'ansible:default'] 

namespace :vagrant do
  desc "Bring up vagrant hosts and configure inventory/vagrant"
  task :up => [ :launch, :config, :groupconfig ] 
  task :launch do
    sh 'vagrant up'
    # capture the ssh config for the vagrant boxes ...
  end
  task :config do 
    sh 'vagrant ssh-config > build/ssh-config'
    # and convert to an ansible inventory file
    sh 'awk -f vagrant-hosts.awk build/ssh-config > inventory/vagrant'
  end
  task :groupconfig do 
    # gather up the groups from hosts.json and write out a group file
    require 'json'
    boxes = JSON.parse(File.read 'hosts.json' )
    groups = boxes.inject(Hash.new) do |acc,box|
      box['groups'] = [ box['groups'] ] if box['groups'].kind_of? String
      box['groups'].each do |group|
        acc[group] ||= []
        acc[group] << box['name']
      end
      acc
    end
    File.open("inventory/groups", "w") do |f|
      groups.each do |group,boxes|
        f.puts "[#{group}]\n#{boxes.join "\n"}"
      end
    end
  end
end

namespace :ansible do
  task :default do
    sh "ansible-playbook -i inventory/ main.yml"
  end
  task :test do
    sh "ansible-playbook -i inventory test.yml -t test"
  end
end
