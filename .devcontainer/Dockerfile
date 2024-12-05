FROM quay.io/devfile/universal-developer-image:ubi8-latest

# Install 
USER root
# Don't include container-selinux and remove
# directories used by yum that are just taking
# up space.
RUN dnf -y module enable container-tools:rhel8; dnf -y update; rpm --restore --quiet shadow-utils; \
dnf -y install crun podman netavark fuse-overlayfs /etc/containers/storage.conf --exclude container-selinux; \
rm -rf /var/cache/* /var/log/dnf* /var/log/yum.*

RUN useradd podman; \
echo podman:10000:5000 > /etc/subuid; \
echo podman:10000:5000 > /etc/subgid;

# Setup internal Podman to pass subscriptions down from host to internal container
# https://issues.redhat.com/browse/RHEL-40706
RUN printf '/run/secrets/etc-pki-entitlement:/run/secrets/etc-pki-entitlement\n/run/secrets/rhsm:/run/secrets/rhsm\n' > /etc/containers/mounts.conf

VOLUME /var/lib/containers
RUN mkdir -p /home/podman/.local/share/containers
RUN mkdir -p /home/podman/.config
RUN chown podman:podman -R /home/podman
VOLUME /home/podman/.local/share/containers

# https://raw.githubusercontent.com/containers/libpod/master/contrib/podmanimage/stable/containers.conf
#ADD containers.conf /etc/containers/containers.conf
# https://raw.githubusercontent.com/containers/libpod/master/contrib/podmanimage/stable/podman-containers.conf
#ADD podman-containers.conf /home/podman/.config/containers/containers.conf

# chmod containers.conf and adjust storage.conf to enable Fuse storage.
#RUN chmod 644 /etc/containers/containers.conf; sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' -e 's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' /etc/containers/storage.conf
#RUN mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers /var/lib/shared/vfs-images /var/lib/shared/vfs-layers; touch /var/lib/shared/overlay-images/images.lock; touch /var/lib/shared/overlay-layers/layers.lock; touch /var/lib/shared/vfs-images/images.lock; touch /var/lib/shared/vfs-layers/layers.lock

ENV _CONTAINERS_USERNS_CONFIGURED=""

# Install Terraform-docs
RUN curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.19.0/terraform-docs-v0.19.0-linux-amd64.tar.gz; \
    tar -xzf terraform-docs.tar.gz; \
    chmod +x terraform-docs; \
    mv terraform-docs /usr/local/bin/terraform-docs

# Getting podman to run
RUN mv /usr/bin/podman.orig /usr/bin/podman

# Install Ansible, Zsh and iputils
RUN yum install -y yum-utils zsh iputils && \
    pip install ansible
    
# Uses "jonathan. Uses some bundled plugins and installs some more from github
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)" -- \
-t jonathan \
-p ansible \
-p terraform \
-p kubectl \
-p helm \
-p oc \
-p aws \
-p podman \
-p https://github.com/zsh-users/zsh-autosuggestions \
-p https://github.com/zsh-users/zsh-completions

# Install lastest AWS CLI
RUN yum remove awscli -y; \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    unzip awscliv2.zip; \
    sudo ./aws/install; \
    rm -rf awscliv2.zip aws
    
USER 1001

# Set default shell to zsh
ENV SHELL=/bin/zsh

# Create workspace dir used by VSCode
# RUN mkdir /opt/app-root/src/workspace/
