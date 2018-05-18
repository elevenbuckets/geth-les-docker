FROM centos:7 
MAINTAINER jasonlin

RUN yum install -y tar openssh-server sudo net-tools openssl-devel initscripts \
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

COPY ./start.sh /usr/bin/
RUN chmod +x /usr/bin/start.sh && rm -f /usr/local/geth*.tar.gz

USER eleven

VOLUME /data

# Define working directory.
WORKDIR /data

EXPOSE 30303
EXPOSE 30303/udp
EXPOSE 30304/udp

CMD ["/usr/bin/start.sh"]
