#!/bin/bash

set -e # Stop on any error

header(){
cat<<EOF
###########################################################################
$1
###########################################################################
EOF
}


if [ ! -d ~/Downloads ] ; then
	mkdir ~/Downloads
fi
cd ~/Downloads

header "install liquid-dsp deps"
sudo apt-get install -y automake autoconf
git clone git://github.com/jgaeddert/liquid-dsp.git
cd liquid-dsp
./bootstrap.sh     # <- only if you cloned the Git repo
./configure
make
sudo make install


header "install reqs"
sudo apt-get install -y qt5-default libfftw3-dev cmake pkg-config build-essential git

header "get other deps"
#Install libliquid1d and libliquid1d-dev from Artful manually by extracting them directly
cd ~/Downloads
wget http://mirrors.kernel.org/ubuntu/pool/universe/l/liquid-dsp/libliquid1d_1.3.0-1_amd64.deb
dpkg -x libliquid1d_1.3.0-1_amd64.deb l1/
sudo cp  l1/usr/lib/x86_64-linux-gnu/libliquid.* /usr/lib/x86_64-linux-gnu/

wget http://mirrors.kernel.org/ubuntu/pool/universe/l/liquid-dsp/libliquid-dev_1.3.0-1_amd64.deb
dpkg -x libliquid-dev_1.3.0-1_amd64.deb l2/
sudo cp -ar l2/usr/include/liquid /usr/include/

header "get repo"
#Clone repository and compile the program
cd ~/Downloads
git clone https://github.com/miek/inspectrum.git

header "build"
cd inspectrum
mkdir build
cd build
cmake ..
make
sudo make install


exit 0

cat>>/home/vagrant/run-gqrx.sh<<EOF
#!/bin/bash

# this one command is important to make sure pulseaudio starts properly
pax11publish -r

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


header "done"
