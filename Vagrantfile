# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "puppetlabs/ubuntu-16.04-64-nocm"
  config.vm.box_version = "1.0.0"

  # config.vm.box_check_update = false
  config.vm.network "forwarded_port", guest: 11090, host: 11090

  config.ssh.forward_x11 = true

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
 
    # Customize the amount of memory on the VM:
    vb.memory = "4096"

# VBoxManage  | grep audio
#    [--audio none|null|oss|alsa|pulse]
#    [--audioin on|off]
#    [--audioout on|off]
#    [--audiocontroller ac97|hda|sb16]
#    [--audiocodec stac9700|ad1980|stac9221|sb16]
#    audioin on|off |
#    audioout on|off |

    # enable audio
    vb.customize ["modifyvm", :id, '--ioapic', 'on', '--audio', 'pulse', '--audiocontroller', 'hda']

# sudo VBoxManage list usbhost
#UUID:               1e1b0811-0d6c-4367-979a-28476534a1e7
#VendorId:           0x0bda (0BDA)
#ProductId:          0x2838 (2838)
#Revision:           1.0 (0100)
#Port:               1
#USB version/speed:  2/High
#Manufacturer:       Realtek
#Product:            RTL2838UHIDIR
#SerialNumber:       00000001
#Address:            sysfs:/sys/devices/pci0000:00/0000:00:14.0/usb3/3-2//device:/dev/vboxusb/003/007
#Current State:      Available

    # enable the RTL-DVR usb stick
    vb.customize ["modifyvm", :id, "--usb", "on"]
    # Bus 003 Device 007: ID 0bda:2838 Realtek Semiconductor Corp. RTL2838 DVB-T
    vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'RTL2838', '--vendorid', '0x0bda', '--productid', '0x2838']

  end

  # patch OS
  config.vm.provision "shell", path: "upgrade-ubuntu.sh", privileged: true

  # install dump1090
  config.vm.provision "shell", path: "install-dump1090.sh", privileged: false

  # install RTL SDR Scanner
  config.vm.provision "shell", path: "install-rtlsdr-scanner.sh", privileged: false

  # install gqrx
  config.vm.provision "shell", path: "install-gqrx.sh", privileged: false

  # reboot once - for drivers - required to turn off TV drivers - modprobe via dump1090
  config.vm.provision "shell", path: "reboot-once.sh", privileged: true

end
