#!/bin/bash
echo "\tActualizando el sistema..."
apt-get update
apt-upgrade
echo "\tCreando directorios necesarios..."
mkdir /usr/local/packer
cd /usr/local/packer/
echo "\tObteniendo packer..."
wget https://releases.hashicorp.com/packer/0.12.3/packer_0.12.3_linux_amd64.zip
unzip packer_0.12.3_linux_amd64.zip
rm ./packer_0.12.3_linux_amd64.zip
export PATH=$PATH:/usr/local/packer
cd /usr/bin
ln -s /usr/local/packer packer
echo "\tObteniendo virtualbox..."
echo "deb http://download.virtualbox.org/virtualbox/debian jessie contrib" >> /etc/apt/sources.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
echo "\tInstalando virtualbox..."
apt-get install virtualbox-5.1
echo "\tObteniendo vagrant..."
wget https://releases.hashicorp.com/vagrant/1.9.2/vagrant_1.9.2_x86_64.deb
echo "\tInstalando vagrant..."
dpkg -i vagrant_1.9.2_x86_64.deb
echo "\tCreando archivo de configuracion packer.json ..."
echo  "{
    "variables": {
        "debian_version": "8.5.0"
    },
  "builders": [
    {
      "type": "virtualbox-iso",
      "boot_command": [
        "<'esc'><wait>",
        "install <wait>",
        "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed_jessie.cfg <wait>",
        "debian-installer=en_US <wait>",
        "auto <wait>",
        "locale=en_US <wait>",
        "kbd-chooser/method=us <wait>",
        "keyboard-configuration/xkb-keymap=us <wait>",
        "netcfg/get_hostname={{ .Name }} <wait>",
        "netcfg/get_domain=vagrantup.com <wait>",
        "fb=false <wait>",
        "debconf/frontend=noninteractive <wait>",
        "console-setup/ask_detect=false <wait>",
        "console-keymaps-at/keymap=us <wait>",
        "<enter><wait>"
      ],
      "boot_wait": "10s",
      "disk_size": 32768,
      "guest_os_type": "Debian_64",
      "headless": true,
      "http_directory": "http",
      "iso_checksum_type": "none",
      "iso_url": "http://cdimage.debian.org/cdimage/release/{{user `debian_version`}}/amd64/iso-cd/debian-{{user `debian_version`}}-amd64-netinst.iso",
      "ssh_username": "vagrant",
      "ssh_password": "vagrant",
      "ssh_port": 22,
      "ssh_wait_timeout": "10000s",
      "shutdown_command": "echo 'vagrant'|sudo -S /sbin/shutdown -hP now",
      "guest_additions_path": "VBoxGuestAdditions_{{.Version}}.iso",
      "virtualbox_version_file": ".vbox_version",
      "vm_name": "debian-{{user `debian_version`}}-amd64",
      "vboxmanage": [
        [ "modifyvm", "{{.Name}}", "--memory", "512" ],
        [ "modifyvm", "{{.Name}}", "--cpus", "1" ]
      ]
    }
  ],
  "post-processors": [
    {
      "type": "vagrant",
      "compression_level": "9",
      "output": "debian-{{user `debian_version`}}-amd64_{{.Provider}}.box",
      "only": ["virtualbox-iso"]
    }
  ]
}" >> /usr/local/packer/packer.json
echo "\tCreando la maquina virtual desde packer.json ..."
echo "\tInstruccion: packer build packer.json ..."
packer build packer.json

