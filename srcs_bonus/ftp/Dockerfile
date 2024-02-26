# FTP on Alpine Linux
FROM alpine:3.19

# Set the TERM environment variable to make sure that the terminal is set up correctly
ENV TERM xterm

# Install FTP server and OpenSSL
RUN apk update && apk upgrade && apk add --no-cache \
    vsftpd

# Configure the FTP server
RUN sed -i "s/#local_enable=YES/local_enable=YES/" /etc/vsftpd/vsftpd.conf && \
    sed -i "s/#write_enable=YES/write_enable=YES/" /etc/vsftpd/vsftpd.conf && \
    sed -i "s/#chroot_local_user=YES/chroot_local_user=YES/" /etc/vsftpd/vsftpd.conf && \
    echo "pasv_enable=YES" >> /etc/vsftpd/vsftpd.conf && \
    echo "pasv_min_port=21000" >> /etc/vsftpd/vsftpd.conf && \
    echo "pasv_max_port=21000" >> /etc/vsftpd/vsftpd.conf && \
    echo "pasv_address=0.0.0.0" >> /etc/vsftpd/vsftpd.conf && \
    echo "local_root=/domains" >> /etc/vsftpd/vsftpd.conf && \
    echo "allow_writeable_chroot=YES" >> /etc/vsftpd/vsftpd.conf && \
    echo "seccomp_sandbox=NO" >> /etc/vsftpd/vsftpd.conf

COPY run.sh /run.sh
RUN chmod +x /run.sh

# Clean up the package repository
RUN rm -f /var/cache/apk/*

ENTRYPOINT ["./run.sh"]
