FROM ubuntu:20.04

MAINTAINER Dmitry Kazakov <dimula73@gmail.com>

# Start off as root
USER root

# Setup the various repositories we are going to need for our dependencies
# Some software demands a newer GCC because they're using C++14 stuff, which is just insane
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates gnupg software-properties-common wget rsync

RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null

RUN echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null

# Some software demands a newer GCC because they're using C++14 stuff, which is just insane
# We do this after the general system update to ensure it doesn't bring in any unnecessary updates
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test

RUN apt-get update && apt-get upgrade -y

RUN add-apt-repository -y ppa:ubuntu-mozilla-security/rust-updates && apt-get update && apt-get install -y cargo rustc

RUN apt-get install -y \
  # General requirements for building KDE software
  build-essential cmake git-core locales \
  # General requirements for building other software
  automake gcc-11 g++-11 libxml-parser-perl libpq-dev libaio-dev \
  # Needed for some frameworks
  bison gettext \
  # Qt and KDE Build Dependencies
  gperf libasound2-dev libatkmm-1.6-dev libbz2-dev libcairo-perl libcap-dev libcups2-dev libdbus-1-dev \
  libdrm-dev libegl1-mesa-dev libfontconfig1-dev libfreetype6-dev libgcrypt-dev libgl1-mesa-dev \
  libglib-perl libgsl0-dev libgsl0-dev gstreamer1.0-alsa libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
  libgtk2-perl libjpeg-dev libnss3-dev libpci-dev libpng-dev libpulse-dev libssl-dev \
  libgstreamer-plugins-good1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly libtiff5-dev libudev-dev libwebp-dev flex libmysqlclient-dev \
  # Mesa libraries for everything to use
  libx11-dev libxkbcommon-x11-dev libxcb-glx0-dev libxcb-keysyms1-dev libxcb-util0-dev libxcb-res0-dev libxcb1-dev libxcomposite-dev libxcursor-dev \
  libxdamage-dev libxext-dev libxfixes-dev libxi-dev libxrandr-dev libxrender-dev libxss-dev libxtst-dev mesa-common-dev \
  # Krita AppImage (Python) extra dependencies
  libffi-dev
 
  
# Krita's dependencies (libheif's avif plugins) need meson and ninja, both aren't available in binary form for 16.04
# The deadsnakes PPA packs setuptools and pip inside python3.9-venv, let's deploy it manually
RUN add-apt-repository -y ppa:deadsnakes/ppa && apt-get update && apt-get install -y python3.9 python3.9-dev python3.9-venv && python3.9 -m ensurepip 
RUN python3.9 -m pip install meson ninja

# Setup a user account for everything else to be done under
RUN useradd -d /home/appimage/ -u 1000 --user-group --create-home -G video appimage

# Get locales in order
RUN locale-gen en_US en_US.UTF-8 en_NZ.UTF-8

# Switch over to our new user and add in the utilities needed for appimage builds
USER appimage
COPY setup-utilities /home/appimage/
RUN /home/appimage/setup-utilities

# Now we go back to being root for the final phase
USER root

CMD tail -f /dev/null
