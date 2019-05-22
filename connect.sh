#echo "Apache2 connecting..." > /usr/lib/cgi-bin/rights.txt

#systemctl stop hostapd.service
#systemctl stop dnsmasq.service

echo "update_config=1
network={
	ssid=\"${1}\"
	psk=\"${2}\"
}" > /etc/wpa_supplicant/wpa_supplicant.conf


cp -R /etc/soilsense/dhcpcd.conf /etc/dhcpcd.conf
#service dhcpcd restart
#systemctl daemon-reload

#wpa_cli enable_network 0


#stop hostapd and dnsmasq services.
service hostapd stop
service dnsmasq stop
 #remove the dnsmasq autostart 
 /usr/sbin/update-rc.d -f dnsmasq remove
  #uninstall and purge the hostapd and dnsmasq packages
  #usudo apt-get autoremove --purge hostapd -yqq
	 #u  sudo apt-get autoremove --purge dnsmasq -yqq
   #delete all the config files
   #rm -rf /etc/dnsmasq.conf
    #rm -rf /etc/hostapd/hostapd.conf
    #rm -rf /etc/network/interfaces
     ##restore original network config
    mv /etc/network/interfaces.backup /etc/network/interfaces
     #restart your device

     wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf

      #reboot
