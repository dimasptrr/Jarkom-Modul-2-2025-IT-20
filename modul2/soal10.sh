#di terminal vingilot
apt update
apt-get install -y nginx php8.4-fpm

mkdir -p /var/www/app.K20.com

echo '<html>
<head><title>Selamat Datang di Vingilot</title></head>
<body>
    <h1>Vingilot Mengisahkan Cerita Dinamis</h1>
    <?php
        echo "<p>Halaman ini disajikan oleh PHP di server: " . $_SERVER["SERVER_NAME"] . "</p>";
    ?>
    <p><a href="/about">Tentang Kami</a></p>
</body>
</html>' > /var/www/app.K20.com/index.php

echo '<html>
<head><title>Tentang Vingilot</title></head>
<body>
    <h1>Tentang Aplikasi Dinamis Ini</h1>
    <p>Ini adalah halaman "About" yang disajikan tanpa ekstensi .php di URL.</p>
</body>
</html>' > /var/www/app.K20.com/about.php


# Berikan kepemilikan seluruh direktori web ke pengguna www-data
chown -R www-data:www-data /var/www/app.K20.com
# Atur izin direktori ke 755 dan file ke 644
find /var/www/app.K20.com -type d -exec chmod 755 {} \;
find /var/www/app.K20.com -type f -exec chmod 644 {} \;

nano /etc/nginx/sites-available/app.K20.com

# Konfigurasi Nginx untuk app.K20.com
# Konfigurasi Nginx untuk app.K20.com (PHP-FPM)

server {
    listen 80;
    server_name app.K20.com;

    root /var/www/app.K20.com;
    index index.php;

    location / {
        # Aturan rewrite yang memungkinkan /about berfungsi
        try_files $uri $uri/ $uri.php =404;
    }

    # Teruskan semua file .php ke PHP-FPM untuk diproses
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        # Pastikan path socket ini benar untuk versi PHP 8.4
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
    }
}

ln -s /etc/nginx/sites-available/app.K20.com /etc/nginx/sites-enabled/
# Hapus link konfigurasi default
rm -f /etc/nginx/sites-enabled/default

nginx -t

/etc/init.d/nginx restart
/etc/init.d/php8.4-fpm restart

#memastikan proses nginx dan php-fpm berjalan
ps aux | grep nginx
ps aux | grep php-fpm

ls -l /var/run/php/

#cek di client manapun(misal: Elrond)
curl http://app.K20.com
#outputnya harusnya <html>

curl http://app.K20.com/about
#outputnya harusnya about.php


