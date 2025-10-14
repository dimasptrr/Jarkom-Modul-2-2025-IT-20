# Di terminal TIRION
nano /etc/bind/named.conf.local

# Tambahkan konfigurasi zona berikut di akhir file named.conf.local
// Zona Reverse DNS untuk segmen DMZ (Soal 8)
zone "3.221.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.192.221.3"; // Nama file untuk data reverse zone
    allow-transfer { 192.221.3.4; };      // Izinkan Valmar untuk menyalin
    notify yes;
};

# Di terminal TIRION
nano /etc/bind/zones/db.192.221.3

# Tambahkan konfigurasi berikut di dalam file db.192.221.3
;
; BIND reverse data file for 192.221.3.0/24
;
$TTL    604800
@       IN      SOA     ns1.K20.com. root.K20.com. (
                              1         ; Serial (Mulai dari 1 untuk zona baru)
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
; Name Servers
@       IN      NS      ns1.K20.com.
@       IN      NS      ns2.K20.com.

; PTR Records (IP -> Hostname)
2       IN      PTR     sirion.K20.com.   ; 192.221.3.2
5       IN      PTR     lindon.K20.com.   ; 192.221.3.5
6       IN      PTR     vingilot.K20.com. ; 192.221.3.6


# Di terminal TIRION
named-checkconf
named-checkzone 3.221.192.in-addr.arpa /etc/bind/zones/db.192.221.3

service bind9 restart

# Di terminal VALMAR
nano /etc/bind/named.conf.local

# Tambahkan konfigurasi zona berikut di akhir file named.conf.local
zone "3.221.192.in-addr.arpa" {
    type slave;
    file "slaves/db.192.221.3";
    masters { 192.221.3.3; };
};

# Di terminal VALMAR
named-checkconf
service bind9 restart

#verifikasi lookup reverse untu sirion
dig -x 192.221.3.2

#Hasil yang Diharapkan:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: ...
;; flags: qr aa rd ra; ...  <-- Perhatikan flag 'aa' (Authoritative)

;; QUESTION SECTION:
;2.3.221.192.in-addr.arpa.      IN      PTR

;; ANSWER SECTION:
2.3.221.192.in-addr.arpa. 604800 IN     PTR     sirion.K20.com. 


#verifikasi lookup reverse untu lindon
dig -x 192.221.3.5

#verifikasi lookup reverse untu vingilot
dig -x 192.221.3.6

