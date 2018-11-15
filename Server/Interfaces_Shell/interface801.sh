# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto em1
iface em1 inet static
        address 172.21.101.1
        netmask 255.255.0.0
auto em2
iface em2 inet static
        address 172.22.101.1
        netmask 255.255.0.0
auto p1p1
iface p1p1 inet static
        address 172.23.101.1
        netmask 255.255.0.0
        gateway 172.23.110.1
auto p1p2
iface p1p2 inet static
        address 172.24.101.1
        netmask 255.255.0.0
        #gateway 172.24.101.200
        post-up route add -net 8.0.0.0/8 gw 172.24.101.200
