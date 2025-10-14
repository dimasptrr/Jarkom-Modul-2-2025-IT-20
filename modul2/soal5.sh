echo "eonwe" > /etc/hostname
echo "earendil" > /etc/hostname
echo "elwing" > /etc/hostname
echo "cirdan" > /etc/hostname
echo "elrond" > /etc/hostname
echo "maglor" > /etc/hostname
echo "sirion" > /etc/hostname
echo "tirion" > /etc/hostname
echo "valmar" > /etc/hostname
echo "lindon" > /etc/hostname
echo "vingilot" > /etc/hostname


# Di terminal Tirion
nano /etc/bind/zones/db.K20.com
#rubah ini
@       IN      SOA     ns1.K20.com. root.K20.com. (
                              4         ; Serial (WAJIB UBAH NOMOR INI!)
                         604800         ; Refresh
...

#lalu tambahkan ini
earendil  IN      A       192.221.1.2
elwing    IN      A       192.221.1.3

cirdan    IN      A       192.221.2.2
elrond    IN      A       192.221.2.3
maglor    IN      A       192.221.2.4

sirion    IN      A       192.221.3.2
lindon    IN      A       192.221.3.5
vingilot  IN      A       192.221.3.6

; A Records for Router Interfaces
eonwe-barat IN    A       192.221.1.1
eonwe-timur IN    A       192.221.2.1
eonwe-dmz   IN    A       192.221.3.1


named-checkconf
named-checkzone K20.com /etc/bind/zones/db.K20.com

service bind9 restart

#cek bebas di semua node
dig earendil.K20.com
dig sirion.K20.com

ping -c 3 vingilot.K20.com
ping -c 3 elwing.K20.com