nano /etc/bind/zones/db.K20.com

#rubah ini
@       IN      SOA     ns1.K20.com. root.K20.com. (
                              6         ; Serial (WAJIB UBAH NOMOR INI!)
                         604800         ; Refresh
...

#tambahkan ini juga

; CNAME Records (Alias untuk layanan)
www       IN      CNAME   sirion.K20.com.
static    IN      CNAME   lindon.K20.com.
app       IN      CNAME   vingilot.K20.com.


# Di terminal TIRION
named-checkconf
named-checkzone K20.com /etc/bind/zones/db.K20.com

service bind9 restart

#di earendil
dig www.K20.com
dig static.K20.com
dig app.K20.com

#di cirdan
dig www.K20.com
dig static.K20.com
dig app.K20.com
