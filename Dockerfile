FROM kdeorg/appimage-1804 as base_image

MAINTAINER Dmitry Kazakov <dimula73@gmail.com>
RUN apt-get update && \
    apt-get -y install curl && \
    apt-get -y install emacs-nox && \
    apt-get -y install gitk git-gui && \
    apt-get -y install cmake-curses-gui gdb valgrind sysvinit-utils && \
    apt-get -y install nomacs && \
    apt-get -y install mesa-utils && \
    apt-get -y install libxcb-icccm4 libxcb-image0 libxcb-render-util0 libxcb-xinerama0

RUN update-alternatives --set gcc /usr/bin/gcc-11
RUN update-alternatives --set g++ /usr/bin/g++-11
    
ENV USRHOME=/home/appimage

RUN chsh -s /bin/bash appimage

RUN locale-gen en_US.UTF-8

RUN echo 'export LC_ALL=en_US.UTF-8' >> ${USRHOME}/.bashrc && \
    echo 'export LANG=en_US.UTF-8'  >> ${USRHOME}/.bashrc && \
    echo "export PS1='\u@\h:\w>'"  >> ${USRHOME}/.bashrc && \
    echo 'source ~/devenv.inc' >> ${USRHOME}/.bashrc && \
    echo 'prepend PATH ~/bin/' >> ${USRHOME}/.bashrc

RUN mkdir -p ${USRHOME}/appimage-workspace/krita.appdir/usr && \
    mkdir -p ${USRHOME}/appimage-workspace/krita-build && \
    mkdir -p ${USRHOME}/bin

COPY ./default-home/devenv.inc \
     ./default-home/.bash_aliases \
     ${USRHOME}/

COPY ./default-home/run_cmake.sh \
     ./default-home/build_krita_appimage.sh \
     ${USRHOME}/bin/

RUN chown appimage:appimage -R ${USRHOME}/
RUN chmod a+rwx /tmp

USER appimage

CMD tail -f /dev/null

FROM base_image

ADD persistent/krita-appimage-deps.ta[r] ${USRHOME}/appimage-workspace/
ADD persistent/qtcreator-package.tar.g[z] ${USRHOME}/

CMD tail -f /dev/null


