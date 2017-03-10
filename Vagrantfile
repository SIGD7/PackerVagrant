# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	#Aqui debe ir tu box nombre/tu box
  config.vm.box = "debian/jessie64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false


  #Habilita estos puertos
  config.vm.network "forwarded_port", guest: 80, host: 8080
  #Obtine todo lo que se va a instalar
  config.vm.provision "shell", path: "config.sh"
end
