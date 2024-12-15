FROM ghcr.io/wheetazlab/ubi-devcontainer:fedora-41


# Set default shell to zsh
ENV SHELL=/bin/zsh

# Create workspace dir used by VSCode
# RUN mkdir /opt/app-root/src/workspace/

# Install systemd
RUN dnf -y install systemd && \
    dnf clean all && \
    (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

# Set systemd as the default command
STOPSIGNAL SIGRTMIN+3
CMD ["/usr/sbin/init"]
