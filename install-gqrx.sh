#!/bin/bash

set -e # Stop on any error

header(){
cat<<EOF
###########################################################################
$1
###########################################################################
EOF
}

header "install reqs"
sudo apt-get install -y x11-apps qt5-default libpulse-dev libfftw3-dev liborc-dev libasound-dev libjack-dev libportaudio-ocaml-dev pulseaudio alsa-utils pavucontrol paman

header "add vagrant to audio groups"
sudo usermod -a -G audio vagrant
sudo usermod -a -G pulse-access vagrant

# this one command is important to make sure pulseaudio starts properly
pax11publish -r

sleep 1
paplay /usr/share/sounds/alsa/Front_Center.wav
sleep 1

header "download and uncompress"
wget https://github.com/csete/gqrx/releases/download/v2.10/gqrx-sdr-2.10-linux-x64.tar.xz
tar xf gqrx-sdr-2.10-linux-x64.tar.xz 
ln -s gqrx-sdr-2.10-linux-x64 gqrx

header "done"

cat>>/home/vagrant/run-gqrx.sh<<EOF
#!/bin/bash
gqrx/gqrx
EOF
chmod 755 ~/run-gqrx.sh


header "done"

sudo tee -a /etc/motd >/dev/null <<EOF

*** gqrx ***
Note: Uses X Windows

http://gqrx.dk/

run  ~/run-gqrx.sh

EOF


