#!/sbin/sh

# The below variables shouldn't need to be changed
# unless you want to call the script something else
SCRIPTNAME="Device_Check"
LOGFILE=/tmp/recovery.log

# Functions for logging to the recovery log
log_info()
{
	echo "I:$SCRIPTNAME:$1" >> "$LOGFILE"
}

log_error()
{
	echo "E:$SCRIPTNAME:$1" >> "$LOGFILE"
}

# Functions to update props using resetprop
update_product_device()
{
	log_info "Current product: $product"
	resetprop "ro.build.product" "$1"
	product=$(getprop ro.build.product)
	log_info "New product: $product"
	log_info "Current device: $device"
	resetprop "ro.product.device" "$1"
	device=$(getprop ro.product.device)
	log_info "New device: $device"
}

update_model()
{
	log_info "Current model: $model"
	resetprop "ro.product.model" "$1"
	model=$(getprop ro.product.model)
	log_info "New model: $model"
}

# These variables will pull directly from getprop output
bootmid=$(getprop ro.boot.mid)
bootcid=$(getprop ro.boot.cid)
device=$(getprop ro.product.device)
hardware=$(getprop ro.hardware)
model=$(getprop ro.product.model)
product=$(getprop ro.build.product)

if [ "$hardware" = 'qcom' ]; then
	for suffix in "" '_a' '_b'; do
		bootpath="/dev/block/bootdevice/by-name/boot$suffix"
		hardware=$(dd if="$bootpath" bs=1024 count=1 2>/dev/null | strings | grep androidboot.hardware | sed "s/.*androidboot.hardware=\([^ ]*\).*/\1/g")
		if [ -n "$hardware" ]; then
			resetprop ro.hardware "$hardware"
			log_info "ro.hardware set to $hardware."
			hardware=$(getprop ro.hardware)
			break
		fi
	done
	if [ ! -n "$hardware" ]; then
		log_error "No hardware value found."
		exit 1
	fi
else
	exit 0
fi

if [ "$hardware" = 'htc_exo' ]; then
	log_info "Updating device properties for Exodus 1..."
	log_info "MID Found: $bootmid"
	log_info "CID Found: $bootcid"

	case $bootmid in
		"2Q5510000")
			## EMEA/Aisa TW/RUS/SEA India Dual-SIM ##
			update_product_device "htc_exodugl";
			update_model "EXODUS 1";
			;;
		"2Q5520000")
			## EMEA/US Unlocked, Single-SIM ##
			update_product_device "htc_exouhl";
			update_model "EXODUS 1";
			;;
		"2Q5530000")
			## CHINA, Dual-SIM ##
			update_product_device "htc_exodtwl";
			update_model "EXODUS 1";
			;;
		*)
			log_error "MID device parameters unknown. Setting default values."
			update_product_device "htc_exodugl";
			update_model "EXODUS 1";
			;;
	esac
	log_info "Updates for Exodus 1 complete. Proceeding with recovery boot."
	exit 0
else
	log_info "Default settings for U12+ already applied. Proceeding with recovery boot."
	exit 0
fi
