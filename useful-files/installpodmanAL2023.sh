#!/bin/bash

# To build podman, you have enough resource on the instance.
# I tested this script on t2.xlarge.

topdir=${HOME}/work
mkdir -p ${topdir}

# Install prereq rpms
sudo dnf install -y git golang libseccomp-devel gpgme-devel autoconf automake libtool yajl yajl-devel libcap-devel systemd-devel cni-plugins iptables-nft rpm-build meson golang-github-cpuguy83-md2man.x86_64

# Build podman
echo "=> Building podman..."
cd ${topdir}
git clone https://github.com/containers/podman
cd podman
git switch v4.5
make
sudo make install

# Build conmon
echo "=> Building conmon..."
cd ${topdir}
git clone https://github.com/containers/conmon
cd conmon
make -j
sudo make install

# Build crun
echo "=> Building crun..."
cd ${topdir}
git clone https://github.com/containers/crun
cd crun
./autogen.sh
./configure --prefix=/usr/local
make -j
sudo make install

# Build libslirp
echo "=> Building libslirp..."
cd ${topdir}
git clone https://gitlab.freedesktop.org/slirp/libslirp.git
cd libslirp
git switch stable-4.2
meson build
ninja -C build
sudo ninja -C build install

# Build slirp4netns
echo "=> Building slirp4netns..."
cd ${topdir}
git clone https://github.com/rootless-containers/slirp4netns.git
cd slirp4netns
git switch release/0.4
./autogen.sh
./configure --prefix=/usr/local
make -j
sudo make install

# Install containers-common
echo "=> Building containers-common..."
mkdir ${topdir}/Downloads
cd ${topdir}/Downloads
curl -LO https://ftp.jaist.ac.jp/pub/Linux/Fedora/updates/37/Everything/source/tree/Packages/c/containers-common-1-82.fc37.src.rpm
rpm -ivh ${topdir}/Downloads/containers-common-1-82.fc37.src.rpm

cd ${HOME}/rpmbuild
rpmbuild -bb SPECS/containers-common.spec
sudo dnf install -y RPMS/noarch/containers-common-1-82.amzn2023.noarch.rpm

# Create /etc/containers directory if it doesn't exist
sudo mkdir -p /etc/containers

# Create /etc/containers/policy.json
sudo tee /etc/containers/policy.json > /dev/null << 'EOF'
{
    "default": [
        {
            "type": "insecureAcceptAnything"
        }
    ],
    "transports": {
        "docker-daemon": {
            "": [
                {
                    "type": "insecureAcceptAnything"
                }
            ]
        }
    }
}
EOF

# Change permissions of the policy.json file
sudo chmod 777 /etc/containers/policy.json

# Run podman
echo "=> Running podman..."
podman run --rm hello-world
