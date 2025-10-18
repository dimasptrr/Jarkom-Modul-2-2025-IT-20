# Jarkom-Modul-2-2025-IT-20
**Laporan Resmi Praktikum Modul 2 — Komunikasi Data & Jaringan Komputer 2025**

## Daftar Anggota

| Nama                  | NRP        |
|-----------------------|------------|
| Zahra Khaalishah      | 5027241070 |
| Dimas Muhammad Putra  | 5027241076 |

---

## Soal 1
Di tepi Beleriand yang porak-poranda, Eonwe merentangkan tiga jalur: Barat untuk 
Earendil dan Elwing, Timur untuk Círdan, Elrond, Maglor, serta pelabuhan DMZ bagi 
Sirion, Tirion, Valmar, Lindon, Vingilot. Tetapkan alamat dan default gateway tiap 
tokoh sesuai glosarium yang sudah diberikan.

Eonwe
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 192.221.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 192.221.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 192.221.3.1
    netmask 255.255.255.0
```
Earendil
```
auto eth0
iface eth0 inet static
    address 192.221.1.2
    netmask 255.255.255.0
    gateway 192.221.1.1
```
Elwing

```
auto eth0
iface eth0 inet static
    address 192.221.1.3
    netmask 255.255.255.0
    gateway 192.221.1.1
```
Cirdan
```
auto eth0
iface eth0 inet static
    address 192.221.2.2
    netmask 255.255.255.0
    gateway 192.221.2.1
```
Elrond
```
auto eth0
iface eth0 inet static
    address 192.221.2.3
    netmask 255.255.255.0
    gateway 192.221.2.1
```
Maglor
```
auto eth0
iface eth0 inet static
    address 192.221.2.4
    netmask 255.255.255.0
    gateway 192.221.2.1
```
Sirion
```
auto eth0
iface eth0 inet static
    address 192.221.3.2
    netmask 255.255.255.0
    gateway 192.221.3.1
```
Tirion
```
auto eth0
iface eth0 inet static
    address 192.221.3.3
    netmask 255.255.255.0
    gateway 192.221.3.1
```
Valmar
```
auto eth0
iface eth0 inet static
    address 192.221.3.4
    netmask 255.255.255.0
    gateway 192.221.3.1
```
Lindon
```
auto eth0
iface eth0 inet static
    address 192.221.3.5
    netmask 255.255.255.0
    gateway 192.221.3.1
```
Vingilot
```
auto eth0
iface eth0 inet static
    address 192.221.3.6
    netmask 255.255.255.0
    gateway 192.221.3.1
```



## Soal 2
Angin dari luar mulai berhembus ketika Eonwe membuka jalan ke awan NAT. Pastikan 
jalur WAN di router aktif dan NAT meneruskan trafik keluar bagi seluruh alamat internal 
sehingga host di dalam dapat mencapai layanan di luar menggunakan IP address.

```
up apt update && apt install -y iptables
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.221.0.0/16
```





## Soal 3
Kabar dari Barat menyapa Timur. Pastikan kelima klien dapat saling berkomunikasi 
lintas jalur (routing internal via Eonwe berfungsi), lalu pastikan setiap host non-router 
menambahkan resolver 192.168.122.1 saat interfacenya aktif agar akses paket dari 
internet tersedia sejak awal. 
```
up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
```


## Soal 4
Para penjaga nama naik ke menara, di Tirion (ns1/master) bangun zona <xxxx>.com 
sebagai authoritative dengan SOA yang menunjuk ke ns1.<xxxx>.com dan catatan NS 
untuk ns1.<xxxx>.com dan ns2.<xxxx>.com. Buat A record untuk ns1.<xxxx>.com 
dan ns2.<xxxx>.com yang mengarah ke alamat Tirion dan Valmar sesuai glosarium, 
serta A record apex <xxxx>.com yang mengarah ke alamat Sirion (front door), aktifkan 
notify dan allow-transfer ke Valmar, set forwarders ke 192.168.122.1. Di Valmar 
(ns2/slave) tarik zona <xxxx>.com dari Tirion dan pastikan menjawab authoritative. pada seluruh host non-router ubah urutan resolver menjadi IP dari ns1.<xxxx>.com → 
ns2.<xxxx>.com → 192.168.122.1. Verifikasi query ke apex dan hostname layanan 
dalam zona dijawab melalui ns1/ns2. 

```
apt update
apt install bind9 -y
```

Di terminal Tirion
```
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
```
Di terminal Tirion
```
nano /etc/bind/named.conf.local

zone "K20.com" {
    type master;
    file "/etc/bind/zones/db.K20.com";    // Lokasi file data zona
    allow-transfer { 192.221.3.4; };      // Izinkan Valmar (IP ns2) untuk menyalin zona
    notify yes;                           // Beri tahu Valmar jika ada pembaruan
};
```

Di terminal Tirion
```
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
```

Di terminal Tirion
```
named-checkconf
named-checkzone K20.com /etc/bind/zones/db.K20.com

ln -s /etc/init.d/named /etc/init.d/bind9

service bind9 restart
```
Di terminal Valmar
```
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
```
Di terminal Valmar
```
named-checkconf
ln -s /etc/init.d/named /etc/init.d/bind9
service bind9 restart
```
Menambahkan di /etc/network/interfaces di semua node
```
up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
       echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
       echo "nameserver 192.221.122.1" >> /etc/resolv.conf
```
Untuk mengecek
```
ping K20.com
```




## Soal 5
“Nama memberi arah,” kata Eonwe. Namai semua tokoh (hostname) sesuai glosarium, 
eonwe, earendil, elwing, cirdan, elrond, maglor, sirion, tirion, valmar, lindon, 
vingilot, dan verifikasi bahwa setiap host mengenali dan menggunakan hostname 
tersebut secara system-wide. Buat setiap domain untuk masing masing node sesuai 
dengan namanya (contoh: eru.<xxxx>.com) dan assign IP masing-masing juga. Lakukan 
pengecualian untuk node yang bertanggung jawab atas ns1 dan ns2 
```
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
```
Di Terminal Terion
```
nano /etc/bind/zones/db.K20.com
```
Rubah ini
```
@       IN      SOA     ns1.K20.com. root.K20.com. (
                              4         ; Serial (WAJIB UBAH NOMOR INI!)
                         604800         ; Refresh
...
```
Kemudian Tambahkan
```
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
```
Cek bebas di semua node
```
dig earendil.K20.com
dig sirion.K20.com

ping -c 3 vingilot.K20.com
ping -c 3 elwing.K20.com
```

## Soal 6
Lonceng Valmar berdentang mengikuti irama Tirion. Pastikan zone transfer berjalan, 
Pastikan Valmar (ns2) telah menerima salinan zona terbaru dari Tirion (ns1). Nilai 
serial SOA di keduanya harus sama.

1. Cek nomor seri di Tirion (Master).
-    Jalankan dari terminal klien manapun (misal: Elrond).
```
dig SOA K20.com @192.221.3.3
```
2. Cek nomor seri di Valmar (Slave).
-    Jalankan dari terminal klien manapun (misal: Elrond).
```
dig SOA K20.com @192.221.3.4
```

1. Buat perubahan di Tirion.
-    a. Buka file zona di terminal TIRION:
```
nano /etc/bind/zones/db.K20.com
```
-    b. NAIKKAN NOMOR SERI (misal, dari 4 menjadi 5). INI WAJIB.
```
      mengubah record SOA menjadi: 
      5       ; Serial (WAJIB UBAH NOMOR INI!)
      tes-transfer  IN      A       1.2.3.4
```
2. Terapkan perubahan di Tirion.
-    a. Periksa sintaks di terminal TIRION:
```
named-checkconf
named-checkzone K20.com /etc/bind/zones/db.K20.com
```
-    b. Restart BIND9 di terminal TIRION (gunakan perintah yang sesuai):
```
service bind9 restart
```
-    c. Pastikan BIND9 masih berjalan di TIRION:
```
ps aux | grep named
```
3. Verifikasi transfer zona di Valmar (Slave).(bebas di semua node)
```
dig SOA K20.com @192.221.3.4
```
```
       -> Hasilnya harus menunjukkan nomor seri yang baru (misal: 5).
```
```
```
-    c. Dari terminal klien, cek record baru di Valmar:
```
dig tes-transfer.K20.com @192.221.3.4
```
-       -> Hasilnya harus menunjukkan A record dengan IP 1.2.3.4.
```
```

## Soal 7
Peta kota dan pelabuhan dilukis. Sirion sebagai gerbang, Lindon sebagai web statis, 
Vingilot sebagai web dinamis. Tambahkan pada zona <xxxx>.com A record untuk 
sirion.<xxxx>.com 
(IP 
Sirion), 
lindon.<xxxx>.com 
vingilot.<xxxx>.com (IP Vingilot). Tetapkan CNAME : - 
www.<xxxx>.com → sirion.<xxxx>.com,  - - 
static.<xxxx>.com → lindon.<xxxx>.com, dan  
app.<xxxx>.com → vingilot.<xxxx>.com.  
(IP 
Lindon), 
dan 
Verifikasi dari dua klien berbeda bahwa seluruh hostname tersebut ter-resolve ke tujuan 
yang benar dan konsisten. 








## Soal 8
Setiap jejak harus bisa diikuti. Di Tirion (ns1) deklarasikan satu reverse zone untuk 
segmen DMZ tempat Sirion, Lindon, Vingilot berada. Di Valmar (ns2) tarik reverse zone 
tersebut sebagai slave, isi PTR untuk ketiga hostname itu agar pencarian balik IP 
address mengembalikan hostname yang benar, lalu pastikan query reverse untuk 
alamat Sirion, Lindon, Vingilot dijawab authoritative.







## Soal 9
Lampion Lindon dinyalakan. Jalankan web statis pada hostname static.<xxxx>.com 
dan buka folder arsip /annals/ dengan autoindex (directory listing) sehingga isinya 
dapat ditelusuri. Akses harus dilakukan melalui hostname, bukan IP. 






## Soal 10
Vingilot mengisahkan cerita dinamis. Jalankan web dinamis (PHP-FPM) pada 
hostname app.<xxxx>.com dengan beranda dan halaman about, serta terapkan rewrite 
sehingga /about berfungsi tanpa akhiran .php. Akses harus dilakukan melalui hostname. 







## Soal 11
Di muara sungai, Sirion berdiri sebagai reverse proxy. Terapkan path-based routing: 
/static → Lindon dan /app → Vingilot, sambil meneruskan header Host dan X-Real-IP 
ke backend. Pastikan Sirion menerima www.<xxxx>.com (kanonik) dan 
sirion.<xxxx>.com, dan bahwa konten pada /static dan /app di-serve melalui backend 
yang tepat. 







## Soal 12
Ada kamar kecil di balik gerbang yakni /admin. Lindungi path tersebut di Sirion 
menggunakan Basic Auth, akses tanpa kredensial harus ditolak dan akses dengan 
kredensial yang benar harus diizinkan. 







## Soal 13
 “Panggil aku dengan nama,” ujar Sirion kepada mereka yang datang hanya menyebut 
angka. Kanonisasikan endpoint, akses melalui IP address Sirion maupun 
sirion.<xxxx>.com harus redirect 301 ke www.<xxxx>.com sebagai hostname 
kanonik. 








## Soal 14
Di Vingilot, catatan kedatangan harus jujur. Pastikan access log aplikasi di Vingilot 
mencatat IP address klien asli saat lalu lintas melewati Sirion (bukan IP Sirion). 





