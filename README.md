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

up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
   echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
   echo "nameserver 192.221.122.1" >> /etc/resolv.conf
```
Elwing

```
auto eth0
iface eth0 inet static
    address 192.221.1.3
    netmask 255.255.255.0
    gateway 192.221.1.1

up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
   echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
   echo "nameserver 192.221.122.1" >> /etc/resolv.conf
```
Cirdan
```
auto eth0
iface eth0 inet static
    address 192.221.2.2
    netmask 255.255.255.0
    gateway 192.221.2.1

up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
   echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
   echo "nameserver 192.221.122.1" >> /etc/resolv.conf
```
Elrond
```
auto eth0
iface eth0 inet static
    address 192.221.2.3
    netmask 255.255.255.0
    gateway 192.221.2.1

up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
   echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
   echo "nameserver 192.221.122.1" >> /etc/resolv.conf
```
Maglor
```
auto eth0
iface eth0 inet static
    address 192.221.2.4
    netmask 255.255.255.0
    gateway 192.221.2.1

up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
   echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
   echo "nameserver 192.221.122.1" >> /etc/resolv.conf
```
Sirion
```
auto eth0
iface eth0 inet static
    address 192.221.3.2
    netmask 255.255.255.0
    gateway 192.221.3.1

up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
   echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
   echo "nameserver 192.221.122.1" >> /etc/resolv.conf
```
Tirion
```
auto eth0
iface eth0 inet static
    address 192.221.3.3
    netmask 255.255.255.0
    gateway 192.221.3.1

up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
   echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
   echo "nameserver 192.221.122.1" >> /etc/resolv.conf
```
Valmar
```
auto eth0
iface eth0 inet static
    address 192.221.3.4
    netmask 255.255.255.0
    gateway 192.221.3.1

up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
   echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
   echo "nameserver 192.221.122.1" >> /etc/resolv.conf
```
Lindon
```
auto eth0
iface eth0 inet static
    address 192.221.3.5
    netmask 255.255.255.0
    gateway 192.221.3.1

up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
   echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
   echo "nameserver 192.221.122.1" >> /etc/resolv.conf
```
Vingilot
```
auto eth0
iface eth0 inet static
    address 192.221.3.6
    netmask 255.255.255.0
    gateway 192.221.3.1

up echo "nameserver 192.221.3.3" > /etc/resolv.conf && \
   echo "nameserver 192.221.3.4" >> /etc/resolv.conf && \
   echo "nameserver 192.221.122.1" >> /etc/resolv.conf
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

- step pertama
```
apt update
apt install bind9 -y
```




## Soal 5
“Nama memberi arah,” kata Eonwe. Namai semua tokoh (hostname) sesuai glosarium, 
eonwe, earendil, elwing, cirdan, elrond, maglor, sirion, tirion, valmar, lindon, 
vingilot, dan verifikasi bahwa setiap host mengenali dan menggunakan hostname 
tersebut secara system-wide. Buat setiap domain untuk masing masing node sesuai 
dengan namanya (contoh: eru.<xxxx>.com) dan assign IP masing-masing juga. Lakukan 
pengecualian untuk node yang bertanggung jawab atas ns1 dan ns2 






## Soal 6
Lonceng Valmar berdentang mengikuti irama Tirion. Pastikan zone transfer berjalan, 
Pastikan Valmar (ns2) telah menerima salinan zona terbaru dari Tirion (ns1). Nilai 
serial SOA di keduanya harus sama.







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





