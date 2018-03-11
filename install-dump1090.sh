#!/bin/bash

# fail on errors
set -e


header(){
cat<<EOF
###########################################################################
$1
###########################################################################
EOF
}

header "modprobe fix"
sudo cat>/tmp/no-rtl.conf<<EOF
#turn off the autoloaded rtl-sdr tv/video
blacklist dvb_usb_rtl28xxu
blacklist rtl2832
blacklist rtl2830
EOF
sudo cp /tmp/no-rtl.conf /etc/modprobe.d/

header "install pre-reqs"
sudo apt-get install -y git-core git cmake build-essential libusb-1.0-0-dev pkg-config 

header "install rtl.sdr repo"
cd ~
git clone git://git.osmocom.org/rtl-sdr.git
cd rtl-sdr
mkdir build
cd build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
sudo make install
sudo ldconfig
sudo cp ~/rtl-sdr/rtl-sdr.rules /etc/udev/rules.d/

header "install mutability/dump1090 repo"
cd ~
git clone https://github.com/mutability/dump1090
cd dump1090
make

mkdir -p public_html/data

cat>>~/run-dump1090.sh<<EOF
#!/bin/bash

cd ~/dump1090

cd public_html
nohup python -m SimpleHTTPServer 11090 &

cd ~/dump1090
nohup ./dump1090 --write-json public_html/data >> log.txt &

echo "Now go to http://localhost:11090/gmap.html"

EOF
chmod 755 ~/run-dump1090.sh

sudo tee -a /etc/motd >/dev/null <<EOF
*** dump1090 ***

https://bl.ocks.org/fasiha/c123a9c6b6c78df7597bb45e0fed808f

run ~/run-dump1090.sh

EOF

header "done"
