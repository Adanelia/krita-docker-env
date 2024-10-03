#!/bin/bash

# Official instructions come from here:
# https://dgpu-docs.intel.com/driver/client/overview.html

cat /home/appimage/intel/intel-graphics-old.gpg | gpg --yes --dearmor --output /usr/share/keyrings/intel-graphics.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/gpu/ubuntu focal client" | \
  tee /etc/apt/sources.list.d/intel-gpu-focal.list

apt update

apt install --upgrade --download-only \
    libdrm-amdgpu1 \
    libdrm-common \
    libdrm-dev \
    libdrm-intel1 \
    libdrm-nouveau2 \
    libdrm-radeon1 \
    libdrm2 \
    libegl-mesa0 \
    libegl1-mesa-dev \
    libgbm1 \
    libgl1-mesa-dev \
    libgl1-mesa-dri \
    libglapi-mesa \
    libgles2-mesa-dev \
    libglx-mesa0 \
    libva-drm2 \
    libva-x11-2 \
    libva2 \
    mesa-common-dev \
    mesa-va-drivers \
    mesa-vdpau-drivers \
    mesa-vulkan-drivers \
    va-driver-all
