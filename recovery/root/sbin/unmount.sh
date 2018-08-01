#!/sbin/sh

# Remove /system bind mount
umount $ANDROID_ROOT
rm -f /system
mkdir /system
