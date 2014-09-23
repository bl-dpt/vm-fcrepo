#!/bin/bash

# These shell commands provision the vagrant box, which is the host
# for the docker containers we're building.
# It needs packer installed in case we gonna use it.
# Alternatively we can use ansible directly (without using the ansible-local
# provisioner from packer), in this case we have to install it.
# Once vagrant is up and running, do packer build <path-to-packer-json>

# NOTE: have implemented a basic proxy detection that can deal with
# nmtl proxies using cntml; this is not done properly and needs the
# vagrant-proxyconf plugin installed
# (see https://github.com/tmatilai/vagrant-proxyconf), the docker containers
# are simply hooked via --net=host and setting their env vars as well.

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
