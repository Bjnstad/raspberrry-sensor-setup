#!/bin/bash

# Makes device ready for production
# Create new User
# Create accesspoint
# Ability for fallback and reset back to hotspot

# Update packages
#apt-get update
#apt-get -y upgrade

# Install requirements for accesspoint dnsmasq and hostapd
#apt-get -y install dnsmasq hostapd

# Stop dnsmasq and hostapd until fully configured
systemctl stop dnsmasq
systemctl stop hostapd

# TODO: May need to reboot

# Configure a static interface on wlan0
# TODO: Maybye add to /etc/dchpcd.conf file
# ip addr flush dev wlan0
ip addr add 192.168.4.1/24 dev wlan0

# Taking backup of dnsmasq.conf, then setting static ip for wlan0 
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
echo "
interface=wlan0
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
" > /etc/dnsmasq.conf

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
