#!/sbin/sh

# Bind mount /data/cache to /cache
mount /data/cache /cache

# Remove /system bind mount
umount $ANDROID_ROOT
rm -f /system
mkdir /system
