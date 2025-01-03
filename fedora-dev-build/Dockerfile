# Use the latest Fedora image
FROM fedora:latest

LABEL org.opencontainers.image.source=https://github.com/wheetazlab/ubi-devcontainer
LABEL name="wheetazlab/ubi-devcontainer"
LABEL version="latest"
LABEL org.opencontainers.image.description="Devcontainer devops multi-arch image"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=/bin/zsh
ENV OC_VERSION=4.15

# Update the system
RUN dnf -y update

# Install required dependencies
RUN dnf -y install \
    sudo \
    curl \
    wget \
    gnupg \
    tar \
    unzip \
    git \
    make \
    gcc \
    jq \
    ps \
    nano \
    podman \
    python3.11 \
    python3-pip \
    awscli \
    openssl \
    glibc-langpack-en \
    glibc-common \
    glibc-locale-source \
    glibc-all-langpacks \
    sshpass \
    krb5-libs \
    libicu \
    && dnf -y clean all --enablerepo='*'

# Install PowerShell 7.4
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        curl -L -o powershell.rpm https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/powershell-7.4.6-1.rh.x86_64.rpm && \
        dnf install -y ./powershell.rpm && \
        rm -f powershell.rpm; \
    elif [ "$ARCH" = "aarch64" ]; then \
        curl -L -o powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.4.6/powershell-7.4.6-linux-arm64.tar.gz && \
        tar -xzf powershell.tar.gz -C /usr/local/bin && \
        chmod +x /usr/local/bin/pwsh && \
        rm -f powershell.tar.gz; \
    fi

# Install the latest Az module for PowerShell
RUN pwsh -Command "Install-Module -Name Az -AllowClobber -Force -Scope AllUsers"

# Install amazon-ssm-agent using RPM
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        curl "https://s3.amazonaws.com/amazon-ssm-us-east-1/latest/linux_amd64/amazon-ssm-agent.rpm" -o "amazon-ssm-agent.rpm"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        curl "https://s3.amazonaws.com/amazon-ssm-us-east-1/latest/linux_arm64/amazon-ssm-agent.rpm" -o "amazon-ssm-agent.rpm"; \
    fi && \
    dnf -y install amazon-ssm-agent.rpm && \
    rm -f amazon-ssm-agent.rpm

# Install aws session-manager-plugin
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_arm64/session-manager-plugin.rpm" -o "session-manager-plugin.rpm"; \
    fi && \
    dnf -y install session-manager-plugin.rpm && \
    rm -f session-manager-plugin.rpm

# Install docker-systemctl-replacement
RUN pip install docker-systemctl-replacement && \
    cp /usr/local/bin/systemctl.py /usr/bin/systemctl

# Set locale environment variables and locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# Set Python 3.11 as the default Python version
RUN alternatives --install /usr/bin/python python /usr/bin/python3.11 1 && \
    alternatives --set python /usr/bin/python3.11 && \
    pip3 install --upgrade pip

# Install pylint and yq
RUN pip install pylint yq

# Install JupyterLab
RUN pip install jupyterlab

# Alias docker to podman
RUN echo "alias docker=podman" >> /etc/profile.d/alias.sh && \
    chmod +x /etc/profile.d/alias.sh

# Install Terraform
RUN dnf install -y dnf-plugins-core && \
    echo -e "[hashicorp]\nname=HashiCorp Stable - $basearch\nbaseurl=https://rpm.releases.hashicorp.com/fedora/41/\$basearch/stable\nenabled=1\ngpgcheck=1\ngpgkey=https://rpm.releases.hashicorp.com/gpg" > /etc/yum.repos.d/hashicorp.repo && \
    dnf -y install terraform

# Install Helm
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install kubectl
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"; \
    fi && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm -f kubectl

# Install Ansible
RUN pip install ansible

# Install Kustomize
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        curl -fsSL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v5.0.0/kustomize_v5.0.0_linux_amd64.tar.gz" | tar -xz -C /usr/local/bin; \
    elif [ "$ARCH" = "aarch64" ]; then \
        curl -fsSL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/v5.0.0/kustomize_v5.0.0_linux_arm64.tar.gz" | tar -xz -C /usr/local/bin; \
    fi && \
    chmod +x /usr/local/bin/kustomize

# Install Azure CLI
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo && \
    dnf -y install azure-cli

# Install OpenShift `oc` CLI
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        curl -L https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable-${OC_VERSION}/openshift-client-linux.tar.gz | tar -C /usr/local/bin -xz --no-same-owner; \
    elif [ "$ARCH" = "aarch64" ]; then \
        curl -L https://mirror.openshift.com/pub/openshift-v4/aarch64/clients/ocp/stable-${OC_VERSION}/openshift-client-linux.tar.gz | tar -C /usr/local/bin -xz --no-same-owner; \
    fi && \
    chmod +x /usr/local/bin/oc

# Install terraform-docs
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.19.0/terraform-docs-v0.19.0-linux-amd64.tar.gz; \
    elif [ "$ARCH" = "aarch64" ]; then \
        curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.19.0/terraform-docs-v0.19.0-linux-arm64.tar.gz; \
    fi && \
    tar -xzf terraform-docs.tar.gz && \
    chmod +x terraform-docs && \
    mv terraform-docs /usr/local/bin/terraform-docs && \
    rm terraform-docs.tar.gz

# Install Zsh with plugins
RUN curl -fsSL https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh -o /tmp/zsh-in-docker.sh && \
    sh /tmp/zsh-in-docker.sh -- \
        -t jonathan \
        -p ansible \
        -p terraform \
        -p kubectl \
        -p helm \
        -p oc \
        -p podman \
        -p https://github.com/zsh-users/zsh-autosuggestions \
        -p https://github.com/zsh-users/zsh-completions && \
    rm /tmp/zsh-in-docker.sh

ENV SHELL=/bin/zsh

RUN dnf -y clean all --enablerepo='*'
