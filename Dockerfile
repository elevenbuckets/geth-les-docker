FROM centos:7 
MAINTAINER jasonlin

RUN yum install -y tar xorg-x11-xinit xorg-x11-server-Xorg xorg-x11-xauth openssh-server sudo cmake net-tools openssl-devel initscripts \
    clang dbus-devel gtk3-devel libnotify-devel libgnome-keyring-devel xorg-x11-server-utils libcap-devel \
    cups-devel libXtst-devel alsa-lib-devel libXrandr-devel libXScrnSaver mesa-dri-drivers \
    dejavu-serif-fonts lklug-fonts smc-fonts-common vlgothic-fonts liberation-sans-fonts sil-padauk-fonts gnu-free-fonts-common sil-abyssinica-fonts lohit-gujarati-fonts lohit-punjabi-fonts fontconfig-devel wqy-microhei-fonts liberation-serif-fonts paratype-pt-sans-fonts gnu-free-serif-fonts dejavu-fonts-common khmeros-base-fonts sil-nuosu-fonts ucs-miscfixed-fonts google-crosextra-caladea-fonts wqy-zenhei-fonts lohit-kannada-fonts open-sans-fonts dejavu-sans-fonts nhn-nanum-fonts-common overpass-fonts lohit-assamese-fonts lohit-telugu-fonts thai-scalable-fonts-common google-crosextra-carlito-fonts libfontenc thai-scalable-waree-fonts smc-meera-fonts dejavu-sans-mono-fonts libreoffice-opensymbol-fonts lohit-devanagari-fonts cjkuni-uming-fonts jomolhari-fonts lohit-oriya-fonts nhn-nanum-gothic-fonts madan-fonts gnu-free-mono-fonts gnu-free-sans-fonts fontconfig ghostscript-fonts lohit-marathi-fonts xorg-x11-font-utils libXfont paktype-naskh-basic-fonts xorg-x11-fonts-Type1 lohit-tamil-fonts lohit-bengali-fonts gnome-font-viewer lohit-nepali-fonts lohit-malayalam-fonts fontpackages-filesystem khmeros-fonts-common liberation-mono-fonts stix-fonts liberation-fonts-common abattis-cantarell-fonts libXfont2 urw-fonts \
    GConf2-devel nss-devel PackageKit-gtk3-module libcanberra-gtk3.x86_64 which && \
    yum group install -y "Development Tools" && \
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y nodejs npm git && \
    yum clean all -y && rm -fr /var/tmp/*

RUN /usr/sbin/sshd-keygen 

RUN groupadd -g 1000 eleven && \
    useradd  -u 1000 -g 1000 -m -d /data eleven && \
    mkdir /usr/local/node_modules && \
    chown -R eleven.eleven /usr/local/node_modules

# limited sudoer
COPY ./SSH_SERV /etc/sudoers.d/
COPY ./sshd_config /etc/ssh/
COPY ./run.sh /usr/bin/
RUN chown root.root /etc/ssh/sshd_config && chmod 600 /etc/ssh/sshd_config && \
    chown root.root /usr/bin/run.sh && chmod +x /usr/bin/run.sh

# geth
COPY ./geth*.tar.gz /usr/local/
RUN tar --strip-components=1 -xf /usr/local/geth*.gz -C /usr/bin

COPY ./start.sh /usr/bin/
RUN chmod +x /usr/bin/start.sh && rm -f /usr/local/geth*.tar.gz

USER eleven

# TODO: setup local nodejs, geth and solc binaries, and CastIron_UI
RUN cd /usr/local/ && \
    npm config set prefix=/usr/local/node_modules && \
    npm install -g npm && \
    npm install -g n

COPY ./nodejs.sh /etc/profile.d/

RUN /bin/bash -l -c "n 8.6.0"

#RUN git clone git@github.com:elevenbuckets/CastIron_UI.git && \
#    cd CastIron_UI && npm install

VOLUME /data

# Define working directory.
WORKDIR /data

EXPOSE 30303
EXPOSE 30303/udp
EXPOSE 30304/udp

CMD ["/usr/bin/start.sh"]
