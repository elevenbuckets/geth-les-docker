FROM centos:7 
MAINTAINER jasonlin

RUN yum update -y && \
    yum install -y tar xorg-x11-xinit xorg-x11-server-Xorg xorg-x11-xauth openssh-server sudo cmake net-tools openssl-devel initscripts \
    clang dbus-devel gtk3-devel libnotify-devel libgnome-keyring-devel xorg-x11-server-utils libcap-devel \
    cups-devel libXtst-devel alsa-lib-devel libXrandr-devel libXScrnSaver \
    GConf2-devel nss-devel && \
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

# geth
COPY ./geth*.tar.gz /usr/local/
RUN tar --strip-components=1 -xf /usr/local/geth*.gz -C /usr/bin

USER eleven

# TODO: setup local nodejs, geth and solc binaries, and CastIron_UI
RUN cd /usr/local/ && \
    npm config set prefix=/usr/local/node_modules && \
    npm install -g npm && \
    npm install -g n

COPY ./nodejs.sh /etc/profile.d/

RUN /bin/bash -l -c "n 8.6.0" && \
    npm --version && \
    node --version

#RUN git clone git@github.com:elevenbuckets/CastIron_UI.git && \
#    cd CastIron_UI && npm install

VOLUME /data

# Define working directory.
WORKDIR /data

EXPOSE 30303
EXPOSE 30303/udp
EXPOSE 30304/udp

CMD ["/usr/bin/sudo","/sbin/sshd","-D"]
