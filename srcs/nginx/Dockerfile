# Utiliza la imagen base Alpine Linux 3.19
FROM alpine:3.19

# Instala NGINX y OpenSSL
RUN apk update && apk add nginx openssl

# Crea directorio para almacenar certificados TLS
RUN mkdir -p /etc/nginx/certs

# Copia los archivos de configuración
COPY nginx.conf /etc/nginx/nginx.conf
COPY javiersa.42.fr.crt /etc/nginx/certs/javiersa.42.fr.crt
COPY javiersa.42.fr.key /etc/nginx/certs/javiersa.42.fr.key

# Exponer el puerto 443
EXPOSE 443

# Iniciar NGINX en primer plano
CMD ["nginx", "-g", "daemon off;"]

