# 1. Cek nomor seri di Tirion (Master).
#    Jalankan dari terminal klien manapun (misal: Elrond).
dig SOA K20.com @192.221.3.3

# 2. Cek nomor seri di Valmar (Slave).
#    Jalankan dari terminal klien manapun (misal: Elrond).
dig SOA K20.com @192.221.3.4


# 1. Buat perubahan di Tirion.
#    a. Buka file zona di terminal TIRION:
nano /etc/bind/zones/db.K20.com

#    b. NAIKKAN NOMOR SERI (misal, dari 4 menjadi 5). INI WAJIB.
      mengubah record SOA menjadi: 
      5       ; Serial (WAJIB UBAH NOMOR INI!)
      tes-transfer  IN      A       1.2.3.4

# 2. Terapkan perubahan di Tirion.
#    a. Periksa sintaks di terminal TIRION:
named-checkconf
named-checkzone K20.com /etc/bind/zones/db.K20.com

#    b. Restart BIND9 di terminal TIRION (gunakan perintah yang sesuai):
service bind9 restart

#    c. Pastikan BIND9 masih berjalan di TIRION:
ps aux | grep named

# 3. Verifikasi transfer zona di Valmar (Slave).(bebas di semua node)
dig SOA K20.com @192.221.3.4
#       -> Hasilnya harus menunjukkan nomor seri yang baru (misal: 5).

#    c. Dari terminal klien, cek record baru di Valmar:
dig tes-transfer.K20.com @192.221.3.4
#       -> Hasilnya harus menunjukkan A record dengan IP 1.2.3.4.