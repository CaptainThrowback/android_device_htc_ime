#
# Copyright 2017 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Release name
PRODUCT_RELEASE_NAME := ime

$(call inherit-product, build/target/product/embedded.mk)

# Inherit from our custom product configuration
$(call inherit-product, vendor/omni/config/common.mk)

# Platform
TARGET_BOARD_PLATFORM := sdm845

# Use the A/B updater.
AB_OTA_UPDATER := true

# Enable update engine sideloading by including the static version of the
# boot_control HAL and its dependencies.
PRODUCT_STATIC_BOOT_CONTROL_HAL := \
    bootctrl.$(TARGET_BOARD_PLATFORM) \
    libgptutils \
    libz

PRODUCT_PACKAGES += \
    update_engine_sideload

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := ime
PRODUCT_NAME := omni_ime
PRODUCT_BRAND := htc
PRODUCT_MODEL := HTC U12+
PRODUCT_MANUFACTURER := HTC

