Playground for the creation of scape VMs
========================================

How to run
----------

# the fedora war has to be put into .provision/fedora4
$ vagrant up
$ vagrant ssh
# then, on the vm:
# (1) build the container
$ packer build /vagrant/.provision/fedora4/pack.json
#
