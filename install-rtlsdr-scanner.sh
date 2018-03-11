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
sudo apt-get install -y python python-wxgtk3.0 python-pip rtl-sdr

header "pip install"
sudo pip install -U rtlsdr_scanner

cat>>~/run-rtlsdr_scanner.sh<<EOF
#!/bin/bash
python -m rtlsdr_scanner
EOF
chmod 755 ~/run-rtlsdr_scanner.sh


sudo tee -a /etc/motd >/dev/null <<EOF

*** RTL SDR Scanner ***
Note: Uses X Windows

https://bl.ocks.org/fasiha/c123a9c6b6c78df7597bb45e0fed808f

run  ~/run-rtlsdr_scanner.sh

EOF

header "done"