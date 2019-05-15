wpa_cli disable_network 0


# Taking backup of dhcpcd.conf, then setting static ip for wlan0 
mv -f /etc/dhcpcd.conf /etc/dhcpcd.conf.orig # TODO: Moves edited file if run twice, maybye check if orig exits?
echo "
interface=wlan0
	static ip_address=192.168.4.1/24
	nohook wpa_supplicant" >> /etc/dhcpcd.conf
ip link set dev wlan0 down
service dhcpcd restart

systemctl restart dnsmasq.service
systemctl restart hostapd.service
