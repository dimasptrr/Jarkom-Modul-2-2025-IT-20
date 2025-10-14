apt update
apt install bind9 -y

# Di terminal Tirion
nano /etc/bind/named.conf.options

options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    recursion yes;

    // TAMBAHKAN BLOK INI:
    allow-recursion {
        localhost;
        192.221.1.0/24; // Izinkan Jalur Barat
        192.221.2.0/24; // Izinkan Jalur Timur
        192.221.3.0/24; // Izinkan Jalur DMZ
    };

    dnssec-validation auto;
    listen-on-v6 { any; };
};

# Di terminal Tirion
nano /etc/bind/named.conf.local

zone "K20.com" {
    type master;
    file "/etc/bind/zones/db.K20.com";    // Lokasi file data zona
    allow-transfer { 192.221.3.4; };      // Izinkan Valmar (IP ns2) untuk menyalin zona
    notify yes;                           // Beri tahu Valmar jika ada pembaruan
};


# Di terminal Tirion
mkdir -p /etc/bind/zones
nano /etc/bind/zones/db.K20.com

$TTL    604800
@       IN      SOA     ns1.K20.com. root.K20.com. (
                              2         ; Serial (PENTING: Naikkan angkanya setiap kali ada perubahan)
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
; Name Servers (NS Records)
@       IN      NS      ns1.K20.com.
@       IN      NS      ns2.K20.com.

; A Records (Pemetaan nama ke IP)
ns1     IN      A       192.221.3.3      ; ns1.K20.com menunjuk ke IP Tirion
ns2     IN      A       192.221.3.4      ; ns2.K20.com menunjuk ke IP Valmar
@       IN      A       192.221.3.2      ; K20.com (apex) menunjuk ke IP Sirion


# Di terminal Tirion
named-checkconf
named-checkzone K20.com /etc/bind/zones/db.K20.com

ln -s /etc/init.d/named /etc/init.d/bind9

service bind9 restart

#di terminal Valmar
apt update
apt install bind9 -y

nano /etc/bind/named.conf.options

options {
        directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    recursion yes;

    // TAMBAHKAN BLOK INI:
    allow-recursion {
        localhost;
        192.221.1.0/24; // Izinkan Jalur Barat
        192.221.2.0/24; // Izinkan Jalur Timur
        192.221.3.0/24; // Izinkan Jalur DMZ
    };

    dnssec-validation auto;
    listen-on-v6 { any; };
};

nano /etc/bind/named.conf.local

zone "K20.com" {
    type slave;
    file "slaves/db.K20.com";
    masters { 192.221.3.3; };    // Tentukan IP Master (Tirion)
};


# Di terminal Valmar
named-checkconf
ln -s /etc/init.d/named /etc/init.d/bind9
service bind9 restart

#menambahkan di /etc/network/interfaces di semua node
up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
       echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
       echo "nameserver 192.221.122.1" >> /etc/resolv.conf

#untuk mengecek
ping K20.com

