#!/bin/sh

if [ -z "$SSL_CERT" ]; then
    echo "\nCopying nginx.conf without SSL support..\n"
    cp /root/nginx.conf /etc/nginx/nginx.conf
else
	SSL_VERIFY_CLIENT=${SSL_VERIFY_CLIENT:-off}
	SSL_CLIENT_CERTIFICATE=${SSL_CLIENT_CERTIFICATE:-/root/ssl/ca.crt}
    echo "\nCopying nginx.conf with SSL support..\n"
    sed -i "s#-x-replace-cert-x-#$SSL_CERT#" /root/nginx_ssl.conf
    sed -i "s#-x-replace-key-x-#$SSL_KEY#" /root/nginx_ssl.conf
	sed -i "s#-x-replace-verify-x-#$SSL_VERIFY_CLIENT#" /root/nginx_ssl.conf
    sed -i "s#-x-replace-client_certificate-x-#$SSL_CLIENT_CERTIFICATE#" /root/nginx_ssl.conf
    cp /root/nginx_ssl.conf /etc/nginx/nginx.conf
fi
chown -R www-data:www-data /var/www/owncloud/data
echo "Starting server..\n"
/etc/init.d/php5-fpm start
/etc/init.d/nginx start
