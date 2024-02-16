#!/bin/sh

adduser -D -H -S -G www-data www-data

mkdir -p /etc/nginx/certs

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certs/$DOMAIN_NAME.key -out /etc/nginx/certs/$DOMAIN_NAME.crt -subj "/C=$CRT_COUNTRY/L=$CRT_LOCATION/O=$CRT_ORG/OU=$CRT_ORG_UNITY/CN=$DOMAIN_NAME"

echo "
user www-data;

# Set number of worker processes automatically based on number of CPU cores.
worker_processes auto;

# Enables the use of JIT for regular expressions to speed-up their processing.
pcre_jit on;

# Configures default error logger.
error_log /var/log/nginx/error.log warn;

# Includes files with directives to load dynamic modules.
include /etc/nginx/modules/*.conf;

# Include files with config snippets into the root context.
include /etc/nginx/conf.d/*.conf;

events {
        # The maximum number of simultaneous connections that can be opened by
        # a worker process.
        worker_connections 1024;
}

http {
        # Includes mapping of file name extensions to MIME types of responses
        # and defines the default type.
        include /etc/nginx/mime.types;
        default_type application/octet-stream;

        # Don't tell nginx version to the clients. Default is 'on'.
        server_tokens off;

        # Specifies the maximum accepted body size of a client request, as
        # indicated by the request header Content-Length. If the stated content
        # length is greater than this size, then the client receives the HTTP
        # error code 413. Set to 0 to disable. Default is '1m'.
        client_max_body_size 64m;

        # Sendfile copies data between one FD and other from within the kernel,
        # which is more efficient than read() + write(). Default is off.
        sendfile on;

        # Causes nginx to attempt to send its HTTP response head in one packet,
        # instead of using partial frames. Default is 'off'.
        tcp_nopush on;

        # Enables the specified protocols. Default is TLSv1 TLSv1.1 TLSv1.2.
        ssl_certificate /etc/nginx/certs/$DOMAIN_NAME.crt;
        ssl_certificate_key /etc/nginx/certs/$DOMAIN_NAME.key;
        ssl_protocols TLSv1.2 TLSv1.3;

        # Specifies that our cipher suits should be preferred over client ciphers.
        # Default is 'off'.
        ssl_prefer_server_ciphers on;

        # Specifies a time during which a client may reuse the session parameters.
        # Default is '5m'.
        ssl_session_timeout 1h;

        # Disable TLS session tickets (they are insecure). Default is 'on'.
        ssl_session_tickets off;

        # Enable gzipping of responses.
        gzip on;

        # Set the Vary HTTP header as defined in the RFC 2616. Default is 'off'.
        gzip_vary on;

        # Helper variable for proxying websockets.
        map \$http_upgrade \$connection_upgrade {
                default upgrade;
                '' close;
        }

        # Specifies the main log format.
        log_format main '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                        '\$status \$body_bytes_sent "\$http_referer" '
                        '"\$http_user_agent" "\$http_x_forwarded_for"';

        # Sets the path, format, and configuration for a buffered log write.
        access_log /var/log/nginx/access.log main;

        # Includes virtual hosts configs.
        include /etc/nginx/http.d/*.conf;

        server {
        listen 443 ssl http2;
        server_name $DOMAIN_NAME;

        index index.php index.html;
        root /domains/$DOMAIN_NAME/public_html;

        location / {
            # First attempt to serve request as file, then
            # as directory, then fall back to displaying a 404.
            try_files \$uri \$uri/ /index.php?\$args;
        }

        location ~ \\.php\$ {
            fastcgi_pass wordpress:9000;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        }

        # Additional security settings (you can customize according to your needs)
        location ~ /\\. {
            deny all;
        }
        location ~ /\\.log\$ {
            deny all;
            access_log off;
            log_not_found off;
        }
    }
}
" > /etc/nginx/nginx.conf

nginx -g "daemon off;"