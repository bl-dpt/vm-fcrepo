#!/bin/bash

# In case you're behind a (e.g. nmlt) proxy, this is a way to have maven working.
# An example/template is available at /vagrant/proxy_settings.conf.example

function installCntlm() {
    # NOTE that this needs apt to be configured with real proxy information..
    apt-get install -y cntlm
    cp /vagrant/proxy_settings.conf /etc/cntlm.conf
    service cntlm restart
}

function reconfigureEnvForCntlm(){
    PORT_NUMBER=`grep Listen /vagrant/proxy_settings.conf| tr -s -d [:alpha:][:space:] "\n"`
    HTTP_PROXY="http://127.0.0.1:$PORT_NUMBER"

    # overwrite system wide http_proxy settings
    # (1) /etc/environment
    echo "HTTP_PROXY=$HTTP_PROXY" >> /etc/environment
    echo "HTTPS_PROXY=$HTTP_PROXY" >> /etc/environment
    echo "FTP_PROXY=$HTTP_PROXY" >> /etc/environment
    # (2) /etc/profile.d/proxy.sh
    echo "export HTTP_PROXY=$HTTP_PROXY" > /etc/profile.d/proxy.sh
    echo "export HTTPS_PROXY=$HTTP_PROXY" >> /etc/profile.d/proxy.sh
    echo "export FTP_PROXY=$HTTP_PROXY" >> /etc/profile.d/proxy.sh
    echo "export http_proxy=$HTTP_PROXY" > /etc/profile.d/proxy.sh
    echo "export https_proxy=$HTTP_PROXY" >> /etc/profile.d/proxy.sh
    echo "export ftp_proxy=$HTTP_PROXY" >> /etc/profile.d/proxy.sh
    echo "export NO_PROXY=\"localhost,127.0.0.1,.example.com\"" >> /etc/profile.d/proxy.sh
    echo "export no_proxy=\"localhost,127.0.0.1,.example.com\"" >> /etc/profile.d/proxy.sh
    # (3) /etc/apt/apt.conf.d
    echo "Acquire::http::Proxy \"$HTTP_PROXY\";" > /etc/apt/apt.conf.d/01proxy;
    echo "Acquire::https::Proxy \"$HTTP_PROXY\";" >> /etc/apt/apt.conf.d/01proxy;
}

if [ -f /vagrant/proxy_settings.conf ]
then
    echo "found proxy_settings, installing cntlm"
    installCntlm
    reconfigureEnvForCntlm
fi

# create a maven dir, necessary for the next steps
if [ ! -d /home/vagrant/.m2 ]
then
    mkdir /home/vagrant/.m2 && chown vagrant:vagrant /home/vagrant/.m2
fi
# check whether there's a maven settings file in /vagrant and link to it if so (in case of proxy settings, etc)
# An example/template is available at /vagrant/maven_settings.xml.example
if [ -f /vagrant/maven_settings.xml ]
then
    echo "found maven_settings, linking to them"
    ln -s /vagrant/maven_settings.xml /home/vagrant/.m2/settings.xml
fi

