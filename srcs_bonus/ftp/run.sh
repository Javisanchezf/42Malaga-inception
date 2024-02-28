#!/bin/sh

# Create user and group
if [ $(getent passwd $FTP_USER) ]; then
    echo "User $FTP_USER already exists"
else
    adduser -D $FTP_USER
    echo "User $FTP_USER created"
    echo "$FTP_USER:$FTP_PASS" | chpasswd
    chown -R $FTP_USER:$FTP_USER /domains
fi

# Start vsftpd
echo "Starting vsftpd"
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf