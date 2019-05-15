#!/bin/bash

systemctl stop hostapd.service
systemctl stop dnsmasq.service

echo "" > /etc/dhcpcd.conf

wpa_cli enable_network 0
