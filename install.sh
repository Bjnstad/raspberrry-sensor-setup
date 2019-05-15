#!/bin/bash

# Makes device ready for production
# TODO: Create new User
# TODO: Create accesspoint
# TODO: Ability for fallback and reset back to hotspot

# Update packages
apt-get update
apt-get -y upgrade

# Install requirements for accesspoint dnsmasq and hostapd
apt-get -y install dnsmasq hostapd

echo "" > /etc/dhcpcd.conf
# Stop dnsmasq and hostapd until fully configured
systemctl stop dnsmasq
systemctl stop hostapd


# Taking backup of dhcpcd.conf, then setting static ip for wlan0 
mv /etc/dhcpcd.conf /etc/dhcpcd.conf.orig # TODO: Moves edited file if run twice, maybye check if orig exits?
echo "
interface=wlan0
	static ip_address=192.168.4.1/24
	nohook wpa_supplicant" >> /etc/dhcpcd.conf
service dhcpcd restart

# Taking backup of dnsmasq.conf, then setting static ip for wlan0 
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig # TODO: Moves edited file if run twice, maybye check if orig exits?
echo "
interface=wlan0
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
" > /etc/dnsmasq.conf
service dhcpcd restart

# Move config file for access point
# TODO: Make access point public open
cp ./configs/hostapd.conf /etc/hostapd/hostapd.conf

# Apply the new config
sed -i 's/#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/g' /etc/default/hostapd

# Start hostapd and dnsmasqi back on
systemctl unmask hostapd
systemctl enable hostapd
systemctl start hostapd
systemctl start dnsmasq

# Add routing and masquerade
sed -i 's/#net.ipv4.ip_forward\=1/net.ipv4.ip_forward\=1/g' /etc/sysctl.conf

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sh -c "iptables-save > /etc/iptables.ipv4.nat"

sed -i 's/exit 0/iptables\-restore \< \/etc\/iptables.ipv4.nat \n exit 0/g' /etc/rc.local


# Install apache2
apt install apache2 -y

# Enable cgi
a2enmod cgi
systemctl restart apache2

# Move app to web root
cp -RF ./app/* /var/www/html



# Make device ready to read moisture

# TODO: Enable SPI in config file

# Install python dev and git
apt-get install git python-dev

cd py-spidev/
python setup.py install
cd ..


