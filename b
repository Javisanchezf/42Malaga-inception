server {
    listen 443 ssl http2;
    server_name root www.root;
    ssl_certificate /etc/nginx/ssl/$DOMAIN_NAME.crt;
    ssl_certificate_key /etc/nginx/ssl/$DOMAIN_NAME.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;

    root /domains/$DOMAIN_NAME/public_html;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf fastcgi_params;
        fastcgi_pass wordpress:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}