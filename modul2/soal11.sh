apt update && apt-get install -y nginx

# Di terminal SIRION
nano /etc/nginx/sites-available/reverse-proxy.conf

# Konfigurasi Nginx untuk Sirion sebagai Reverse Proxy
server {
    listen 80;

    # Sirion akan merespons kedua hostname ini
    server_name www.K20.com sirion.K20.com;

    # LOKASI 1: Path-based routing untuk konten statis
    # Semua request yang dimulai dengan /static/ akan diteruskan ke Lindon
    location /static/ {
        # Alamat backend server Lindon
        proxy_pass http://192.221.3.5/;

        # Meneruskan header penting ke backend
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # LOKASI 2: Path-based routing untuk konten dinamis
    # Semua request yang dimulai dengan /app/ akan diteruskan ke Vingilot
    location /app/ {
        # Alamat backend server Vingilot
        proxy_pass http://192.221.3.6/;
        
        # Meneruskan header penting ke backend
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# Di terminal SIRION
# Buat symbolic link untuk mengaktifkan konfigurasi
ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/

# Hapus link konfigurasi default jika ada
rm -f /etc/nginx/sites-enabled/default

# Periksa apakah konfigurasi Nginx bebas dari kesalahan sintaks
nginx -t

# Restart layanan Nginx
/etc/init.d/nginx restart

# Pastikan proses Nginx sedang berjalan
ps aux | grep nginx

#cek di client manapun(misal: Earendil)
curl http://www.K20.com/static/

# Dari terminal Earendil
curl http://www.K20.com/app/about

# Dari terminal Earendil
curl http://www.K20.com/app/
