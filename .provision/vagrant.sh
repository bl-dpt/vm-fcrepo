#!/bin/bash

PACKER_VERSION="packer_0.7.1_linux_amd64"
PACKER_URL="https://dl.bintray.com/mitchellh/packer/$PACKER_VERSION.zip"
PACKER_BINS=/usr/local/packer

apt-get update

function installPacker() {
  wget $PACKER_URL
  apt-get install -y unzip
  unzip ${PACKER_VERSION}.zip -d $PACKER_BINS
  # this writes PATH another time to /etc/environment, but like this
  # we don't overwrite other variables potentially set there
  echo "PATH=${PATH}:${PACKER_BINS}" >> /etc/environment
  source /etc/environment
}

function installAnsible() {
  echo "installing pip.."
  apt-get install -y python-pip python-dev
  echo "installing ansible via pip.."
  pip install ansible
}

########
# MAIN #
########

source /vagrant/provision/proxy_detection.sh
installPacker
