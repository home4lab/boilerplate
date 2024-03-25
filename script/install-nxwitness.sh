echo "installing prerequisite..."

apt install cifs-utils net-tools

echo "installing package nxwitness..."

dpkg -i nxwitness-server-5.1.2.37996-linux_x64.deb

echo "check if needed package still missing..."

apt -f install

echo "check port already listening or not..."

netstat -tulpn | grep 7001
