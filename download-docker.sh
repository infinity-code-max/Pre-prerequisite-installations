#!/bin/bash

choose_os() {
    echo "[CentOS, Ubuntu, AmazonLinux, RHEL]"
    read -p "Choose the Linux type: " Ltype
    operation "$Ltype"
}

operation() {
    local os=$(echo "$1" | tr '[:upper:]' '[:lower:]')

    {
        set -e

        if [ "$os" == "centos" ]; then
            sudo yum update -y
            success_update

            sudo yum install -y yum-utils
            sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            sudo yum install -y docker-ce docker-ce-cli containerd.io
            sudo systemctl enable --now docker
            success_download

        elif [ "$os" == "ubuntu" ]; then
            sudo apt update -y
            sudo apt upgrade -y
            success_update

            sudo apt install -y docker.io
            sudo systemctl enable --now docker
            success_download

        elif [ "$os" == "amazonlinux" ]; then
            sudo yum update -y
            success_update

            sudo amazon-linux-extras install docker -y
            sudo systemctl enable --now docker
            success_download

        elif [ "$os" == "rhel" ]; then
            sudo dnf update -y
            success_update

            sudo dnf install -y dnf-plugins-core
            sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
            sudo dnf install -y docker-ce docker-ce-cli containerd.io
            sudo systemctl enable --now docker
            success_download

        else
            echo "❌ Invalid OS selected"
            return 1
        fi

    } || {
        echo "❌ Error occurred during operation on OS: $os"
        return 1
    }

    echo "✅ Docker setup completed on $os"
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
