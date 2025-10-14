# Interface menuju Internet (NAT1) - terhubung ke eth0
auto eth0
iface eth0 inet dhcp

# Interface menuju Jalur Barat - terhubung ke eth1
auto eth1
iface eth1 inet static
    address 192.221.1.1
    netmask 255.255.255.0

# Interface menuju Jalur Timur - terhubung ke eth2
auto eth2
iface eth2 inet static
    address 192.221.2.1
    netmask 255.255.255.0

# Interface menuju Jalur Pelabuhan/DMZ - terhubung ke eth3
auto eth3
iface eth3 inet static
    address 192.221.3.1
    netmask 255.255.255.0

up apt update && apt install -y iptables
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.221.0.0/16


#   2. JALUR BARAT (GATEWAY: 192.221.1.1)
########## Konfigurasi untuk: Earendil ##########
# Lokasi file: /etc/network/interfaces di node Earendil
auto eth0
iface eth0 inet static
    address 192.221.1.2
    netmask 255.255.255.0
    gateway 192.221.1.1
up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
       echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
       echo "nameserver 192.221.122.1" >> /etc/resolv.conf

########## Konfigurasi untuk: Elwing ##########
# Lokasi file: /etc/network/interfaces di node Elwing
auto eth0
iface eth0 inet static
    address 192.221.1.3
    netmask 255.255.255.0
    gateway 192.221.1.1
up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
       echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
       echo "nameserver 192.221.122.1" >> /etc/resolv.conf


#   3. JALUR TIMUR (GATEWAY: 192.221.2.1)

########## Konfigurasi untuk: Círdan ##########
auto eth0
iface eth0 inet static
    address 192.221.2.2
    netmask 255.255.255.0
    gateway 192.221.2.1
up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
       echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
       echo "nameserver 192.221.122.1" >> /etc/resolv.conf


########## Konfigurasi untuk: Elrond ##########
auto eth0
iface eth0 inet static
    address 192.221.2.3
    netmask 255.255.255.0
    gateway 192.221.2.1
up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
       echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
       echo "nameserver 192.221.122.1" >> /etc/resolv.conf


########## Konfigurasi untuk: Maglor ##########
auto eth0
iface eth0 inet static
    address 192.221.2.4
    netmask 255.255.255.0
    gateway 192.221.2.1
up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
       echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
       echo "nameserver 192.221.122.1" >> /etc/resolv.conf


#   4. JALUR PELABUHAN / DMZ (GATEWAY: 192.221.3.1)

########## Konfigurasi untuk: Sirion (Reverse Proxy) ##########
auto eth0
iface eth0 inet static
    address 192.221.3.2
    netmask 255.255.255.0
    gateway 192.221.3.1
up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
       echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
       echo "nameserver 192.221.122.1" >> /etc/resolv.conf


########## Konfigurasi untuk: Tirion (NS1) ##########
auto eth0
iface eth0 inet static
    address 192.221.3.3
    netmask 255.255.255.0
    gateway 192.221.3.1
up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
       echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
       echo "nameserver 192.221.122.1" >> /etc/resolv.conf


########## Konfigurasi untuk: Valmar (NS2) ##########
auto eth0
iface eth0 inet static
    address 192.221.3.4
    netmask 255.255.255.0
    gateway 192.221.3.1
up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
       echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
       echo "nameserver 192.221.122.1" >> /etc/resolv.conf


########## Konfigurasi untuk: Lindon (Web Statis) ##########
auto eth0
iface eth0 inet static
    address 192.221.3.5
    netmask 255.255.255.0
    gateway 192.221.3.1
up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
       echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
       echo "nameserver 192.221.122.1" >> /etc/resolv.conf


########## Konfigurasi untuk: Vingilot (Web Dinamis) ##########
auto eth0
iface eth0 inet static
    address 192.221.3.6
    netmask 255.255.255.0
    gateway 192.221.3.1
up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
       echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
       echo "nameserver 192.221.122.1" >> /etc/resolv.conf