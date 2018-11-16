# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto em1
iface em1 inet static
	address 172.21.101.5
	netmask 255.255.0.0
	network 172.21.0.0
	broadcast 172.21.255.255
auto em2
iface em2 inet static
	address 172.22.101.5
	netmask 255.255.0.0
	network 172.22.0.0
	broadcast 172.22.255.255
