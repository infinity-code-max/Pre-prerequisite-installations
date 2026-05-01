#!/bin/bash

choose_os() {
    echo "[CentOS, Ubuntu, AmazonLinux, RHEL]"
    read -p "Choose the Linux type: " Ltype
    operation "$Ltype"
}

operation() {
    local os=$(echo "$1" | tr '[:upper:]' '[:lower:]')

    set -e

    if [ "$os" == "centos" ]; then
        sudo yum update -y && success_update

        echo "Disabling swap..."
        sudo swapoff -a

        echo "Adding Kubernetes repo..."
        cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/repodata/repomd.xml.key
EOF

        sudo yum install -y kubelet kubeadm kubectl

    elif [ "$os" == "ubuntu" ]; then
        sudo apt update -y && sudo apt upgrade -y && success_update

        echo "Disabling swap..."
        sudo swapoff -a

        sudo apt install -y apt-transport-https ca-certificates curl

        echo "Adding Kubernetes repo..."
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | \
        sudo tee /etc/apt/keyrings/kubernetes-apt-keyring.asc

        echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.asc] \
https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" | \
        sudo tee /etc/apt/sources.list.d/kubernetes.list

        sudo apt update -y
        sudo apt install -y kubelet kubeadm kubectl
	success_download


    elif [ "$os" == "amazonlinux" ]; then
        sudo yum update -y && success_update

        echo "Disabling swap..."
        sudo swapoff -a

        echo "Adding Kubernetes repo..."
        cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/repodata/repomd.xml.key
EOF

        sudo yum install -y kubelet kubeadm kubectl
	success_download

    elif [ "$os" == "rhel" ]; then
        sudo dnf update -y && success_update

        echo "Disabling swap..."
        sudo swapoff -a

        echo "Adding Kubernetes repo..."
        cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/repodata/repomd.xml.key
EOF

        sudo dnf install -y kubelet kubeadm kubectl
	success_download

    else
        echo "❌ Invalid OS selected"
        exit 1
    fi

    echo "Enabling kubelet service..."
    sudo systemctl enable --now kubelet

    echo "✅ Kubernetes components installed successfully"
}
success_update() {
    echo "########################################"
    echo "✅ Successfully updated"
    echo "########################################"
}

success_download() {
	echo "####################################"
	echo "--------successfully downloaded---------"
	echo "####################################"
}

choose_os
