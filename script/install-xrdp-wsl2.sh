#!/bin/bash

# Install XFCE4 and necessary packages
sudo apt update
sudo apt install -y xrdp xfce4 xfce4-goodies

# Backup the xrdp.ini file
sudo cp /etc/xrdp/xrdp.ini /etc/xrdp/xrdp.ini.bak

# Modify the xrdp.ini file
sudo sed -i 's/3389/3390/g' /etc/xrdp/xrdp.ini
sudo sed -i 's/max_bpp=32/#max_bpp=32\nmax_bpp=128/g' /etc/xrdp/xrdp.ini
sudo sed -i 's/xserverbpp=24/#xserverbpp=24\nxserverbpp=128/g' /etc/xrdp/xrdp.ini

# Set the session to XFCE
echo xfce4-session > ~/.xsession

# Edit the startwm.sh file
sudo sed -i 's/^test -x \/etc\/x11/#&/g' /etc/xrdp/startwm.sh
sudo sed -i 's/^\/bin\/sh \/etc\/x11/#&/g' /etc/xrdp/startwm.sh
echo 'startxfce4' | sudo tee -a /etc/xrdp/startwm.sh

# Start the XRDP service
sudo /etc/init.d/xrdp start

echo "Setup complete. You can now connect to localhost:3390 using Remote Desktop."
