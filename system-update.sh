#!/bin/bash

choose_os() {
    echo "[CentOS, Ubuntu, AmazonLinux, RHEL]"
    read -p "Choose the Linux type: " Ltype
    operation "$Ltype"
}

operation() {
    local os=$(echo "$1" | tr '[:upper:]' '[:lower:]')

    if [ "$os" == "centos" ]; then
        sudo yum update -y && success_update

    elif [ "$os" == "ubuntu" ]; then
        sudo apt update -y && sudo apt upgrade -y && success_update

    elif [ "$os" == "amazonlinux" ]; then
        sudo yum update -y && success_update   # safer default

    elif [ "$os" == "rhel" ]; then
        sudo dnf update -y && success_update

    else
        echo "❌ Invalid OS selected"
        exit 1
    fi
}

success_update() {
    echo "########################################"
    echo "✅ Successfully updated"
    echo "########################################"
}

choose_os
