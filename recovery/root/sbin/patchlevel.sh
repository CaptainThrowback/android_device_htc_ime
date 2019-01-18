#!/sbin/sh

finish()
{
	umount /v
	umount /s
	rmdir /v
	rmdir /s
	setprop fde.ready 1
	exit 0
}

osver=$(getprop ro.build.version.release_orig)
patchlevel=$(getprop ro.build.version.security_patch_orig)
suffix=$(getprop ro.boot.slot_suffix)

if [ -z "$suffix" ]; then
	suf=$(getprop ro.boot.slot)
	suffix="_$suf"
fi

venpath="/dev/block/bootdevice/by-name/vendor$suffix"
mkdir /v
mount -t ext4 -o ro "$venpath" /v
syspath="/dev/block/bootdevice/by-name/system$suffix"
mkdir /s
mount -t ext4 -o ro "$syspath" /s

if [ -f /s/system/build.prop ]; then
	# TODO: It may be better to try to read these from the boot image than from /system
	osver=$(grep -i 'ro.build.version.release' /s/system/build.prop  | cut -f2 -d'=' -s)
	patchlevel=$(grep -i 'ro.build.version.security_patch' /s/system/build.prop  | cut -f2 -d'=' -s)
	if [ ! -z "$osver" ]; then
		resetprop ro.build.version.release "$osver"
		sed -i "s/ro.build.version.release=.*/ro.build.version.release="$osver"/g" /prop.default ;
	fi
	if [ ! -z "$patchlevel" ]; then
		resetprop ro.build.version.security_patch "$patchlevel"
		sed -i "s/ro.build.version.security_patch=.*/ro.build.version.security_patch="$patchlevel"/g" /prop.default ;
	fi
	# Set additional props from build.prop
	device=$(grep -i 'ro.product.device' /s/system/build.prop  | cut -f2 -d'=' -s)
	fingerprint=$(grep -i 'ro.build.fingerprint' /s/system/build.prop  | cut -f2 -d'=' -s)
	product=$(grep -i 'ro.build.product' /s/system/build.prop  | cut -f2 -d'=' -s)
	if [ ! -z "$device" ]; then
		resetprop ro.product.device "$device"
		sed -i "s/ro.product.device=.*/ro.product.device="$device"/g" /prop.default ;
	fi
	if [ ! -z "$fingerprint" ]; then
		resetprop ro.build.fingerprint "$fingerprint"
		sed -i "s/ro.build.fingerprint=.*/ro.build.fingerprint="$osver"/g" /prop.default ;
	fi
	if [ ! -z "$product" ]; then
		resetprop ro.build.product "$product"
		sed -i "s/ro.build.product=.*/ro.build.product="$product"/g" /prop.default ;
	fi
	# Load Tuxera exfat module
	if [ -f /v/lib/modules/texfat.ko ]; then
		insmod /v/lib/modules/texfat.ko
	fi
	finish
else
	# Be sure to increase the PLATFORM_VERSION in build/core/version_defaults.mk to override Google's anti-rollback features to something rather insane
	if [ ! -z "$osver" ]; then
		resetprop ro.build.version.release "$osver"
		sed -i "s/ro.build.version.release=.*/ro.build.version.release="$osver"/g" /prop.default ;
	fi
	if [ ! -z "$patchlevel" ]; then
		resetprop ro.build.version.security_patch "$patchlevel"
		sed -i "s/ro.build.version.security_patch=.*/ro.build.version.security_patch="$patchlevel"/g" /prop.default ;
	fi
	# Load Tuxera exfat module
	if [ -f /v/lib/modules/texfat.ko ]; then
		insmod /v/lib/modules/texfat.ko
	fi
	finish
fi
