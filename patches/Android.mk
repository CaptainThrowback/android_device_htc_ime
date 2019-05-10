LOCAL_PATH := $(call my-dir)

# Dummy file to apply post-install patch for screenshot
include $(CLEAR_VARS)

LOCAL_MODULE := $(TARGET_DEVICE)_screenshot
LOCAL_MODULE_TAGS := optional eng
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/postinstall
LOCAL_REQUIRED_MODULES := teamwin
LOCAL_POST_INSTALL_CMD += \
    $(hide) sed -i 's:power+voldown:power+home:' $(TARGET_RECOVERY_ROOT_OUT)/twres/portrait.xml; \
    sed -i 's:power+voldown:power+home:' $(TARGET_RECOVERY_ROOT_OUT)/twres/ui.xml;
include $(BUILD_PHONY_PACKAGE)

# Dummy file to copy bootctrl to vendor
include $(CLEAR_VARS)

LOCAL_MODULE := copy_bootctrl
LOCAL_MODULE_TAGS := optional eng
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/postinstall
LOCAL_REQUIRED_MODULES := teamwin
LOCAL_POST_INSTALL_CMD += \
    $(hide) mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/vendor/lib64/hw; \
    cp -rf $(TARGET_OUT_VENDOR)/lib64/hw/bootctrl.$(TARGET_BOARD_PLATFORM).so \
    $(TARGET_RECOVERY_ROOT_OUT)/vendor/lib64/hw/bootctrl.$(TARGET_BOARD_PLATFORM).so;
include $(BUILD_PHONY_PACKAGE)
