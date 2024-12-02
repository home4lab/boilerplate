#!/bin/bash

# Prompt user to choose the installation type
echo "Select the installation type:"
echo "1) Splunk Server"
echo "2) Splunk Forwarder"
read -p "Enter the number (1 or 2): " type_choice

if [ "$type_choice" -eq 1 ]; then
    # Splunk Server installation script
    echo "Select the installation method:"
    echo "1) Debian-based (.deb)"
    echo "2) RHEL-based (.rpm)"
    read -p "Enter the number (1 or 2): " install_choice

    # Define variables for URLs and file names
    DEB_URL="https://download.splunk.com/products/splunk/releases/9.3.2/linux/splunk-9.3.2-d8bb32809498-linux-2.6-amd64.deb"
    RPM_URL="https://download.splunk.com/products/splunk/releases/9.3.2/linux/splunk-9.3.2-d8bb32809498.x86_64.rpm"
    DEB_FILE="splunk-9.3.2-d8bb32809498-linux-2.6-amd64.deb"
    RPM_FILE="splunk-9.3.2-d8bb32809498.x86_64.rpm"

    # Download and install based on user choice
    if [ "$install_choice" -eq 1 ]; then
        wget -O $DEB_FILE $DEB_URL
        sudo dpkg -i $DEB_FILE
    elif [ "$install_choice" -eq 2 ]; then
        wget -O $RPM_FILE $RPM_URL
        sudo rpm -ivh $RPM_FILE
    else
        echo "Invalid choice."
        exit 1
    fi

    # Ask for user input for password admin with masked input
    echo -n "Enter password for admin: "
    stty -echo
    read passadmin
    stty echo
    echo

    # Start Splunk for the first time to initialize
    sudo /opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd $passadmin

    # Add configuration to enable SSL and change the HTTP port to 443 in Splunk web.conf
    echo "[settings]" | sudo tee -a /opt/splunk/etc/system/local/web.conf
    echo "httpport = 443" | sudo tee -a /opt/splunk/etc/system/local/web.conf
    echo "enableSplunkWebSSL = true" | sudo tee -a /opt/splunk/etc/system/local/web.conf

    # Restart Splunk to apply the new configuration
    sudo /opt/splunk/bin/splunk restart

elif [ "$type_choice" -eq 2 ]; then
    # Splunk Forwarder installation script
    echo "Select the installation method:"
    echo "1) Debian-based (.deb)"
    echo "2) RHEL-based (.rpm)"
    read -p "Enter the number (1 or 2): " install_choice

    # Define variables for URLs and file names
    DEB_URL="https://download.splunk.com/products/universalforwarder/releases/9.3.2/linux/splunkforwarder-9.3.2-d8bb32809498-linux-2.6-amd64.deb"
    RPM_URL="https://download.splunk.com/products/universalforwarder/releases/9.3.2/linux/splunkforwarder-9.3.2-d8bb32809498.x86_64.rpm"
    DEB_FILE="splunkforwarder-9.3.2-d8bb32809498-linux-2.6-amd64.deb"
    RPM_FILE="splunkforwarder-9.3.2-d8bb32809498.x86_64.rpm"

    # Download and install based on user choice
    if [ "$install_choice" -eq 1 ]; then
        wget -O $DEB_FILE $DEB_URL
        sudo dpkg -i $DEB_FILE 
    elif [ "$install_choice" -eq 2 ]; then
        wget -O $RPM_FILE $RPM_URL
        sudo rpm -ivh $RPM_FILE
    else
        echo "Invalid choice."
        exit 1
    fi

    # Ask for user input for forward-server configuration
    read -p "Enter the Server Domain or IP address : " input_server
    read -p "Enter the Server port number: " input_port

    # Ask for user input for password admin with masked input
    echo -n "Enter password for admin: "
    stty -echo
    read passadmin
    stty echo
    echo

    # Start Splunk Forwarder
    sudo /opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd $passadmin

    # Add path to monitor
    sudo /opt/splunkforwarder/bin/splunk add monitor /var/log/

    # Add the forward-server using user inputs
    sudo /opt/splunkforwarder/bin/splunk add forward-server $input_server:$input_port

    # Restart Splunk Forwarder to apply the new configuration
    sudo /opt/splunkforwarder/bin/splunk restart
else
    echo "Invalid choice."
    exit 1
fi

