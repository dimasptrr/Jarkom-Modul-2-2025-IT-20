apt update && apt-get install -y nginx

# Di terminal LINDON
# Buat direktori utama untuk situs
mkdir -p /var/www/static.K20.com

# Buat halaman utama (index.html)
echo '<html><body><h1>Lampion Lindon Menyala!</h1><p>Ini adalah konten statis yang disajikan dari pelabuhan Lindon.</p><p>Kunjungi <a href="/annals/">arsip kami</a>.</p></body></html>' > /var/www/static.K20.com/index.html

# Buat direktori arsip /annals/
mkdir -p /var/www/static.K20.com/annals

# Buat beberapa file contoh di dalam /annals/ agar ada isinya
touch /var/www/static.K20.com/annals/catatan_perjalanan.txt
touch /var/www/static.K20.com/annals/peta_beleriand.png
touch /var/www/static.K20.com/annals/dokumen_rahasia.pdf

# Di terminal LINDON
nano /etc/nginx/sites-available/static.K20.com

# Konfigurasi Nginx untuk static.K20.com

server {
    listen 80;
    server_name static.K20.com;

    # Tentukan direktori root tempat file website disimpan
    root /var/www/static.K20.com;
    index index.html;

    # Konfigurasi standar untuk menangani request
    location / {
        try_files $uri $uri/ =404;
    }

    # Konfigurasi khusus untuk folder /annals/
    location /annals/ {
        # AKTIFKAN AUTOINDEX (DIRECTORY LISTING) DI SINI
        autoindex on;
    }
}

# Di terminal LINDON
# Buat symbolic link untuk mengaktifkan konfigurasi situs
ln -s /etc/nginx/sites-available/static.K20.com /etc/nginx/sites-enabled/

# Hapus link konfigurasi default agar tidak terjadi konflik
rm /etc/nginx/sites-enabled/default

# Periksa apakah konfigurasi Nginx bebas dari kesalahan sintaks
nginx -t

# Restart layanan Nginx menggunakan perintah yang sesuai untuk sistem Anda
/etc/init.d/nginx restart

# Pastikan proses Nginx sedang berjalan
ps aux | grep nginx

#cek di client manapun(misal: Earendil)
curl http://static.K20.com
#outputnya harusnya <html><body><h1>Lampion Lindon Menyala!</h1><p>Ini adalah konten statis yang disajikan dari pelabuhan Lindon.</p><p>Kunjungi <a href="/annals/">arsip kami</a>.</p></body></html>

# Dari terminal Earendil
curl http://static.K20.com/annals/
#outputnya harusnya Index of /annals/