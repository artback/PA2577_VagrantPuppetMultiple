Vagrant.configure(2) do |config|
config.vm.box = "bento/ubuntu-18.04"

config.vm.provision "shell", inline: <<-SHELL
  wget https://apt.puppetlabs.com/puppet5-release-$(lsb_release -cs).deb
  dpkg -i puppet5-release-$(lsb_release -cs).deb
  apt-get -qq update
  apt-get install -y puppet-agent
SHELL

config.vm.provision "puppet" do |puppet|
  puppet.environment_path="environments"
  puppet.environment="test"
end

config.vm.define "appserver" do | appserver| 
  appserver.vm.hostname = "appserver"
end

config.vm.define "dbserver" do | dbserver | 
  dbserver.vm.hostname = "dbserver"
end

config.vm.define "web" do | web | 
  web.vm.hostname = "web"
  web.vm.network "forwarded_port", guest: 80, host: 8080
end

(1..3).each do |i|
  config.vm.define "test-#{i}" do |test| 
    test.vm.hostname = "tst-#{i}"
  end
end

end
