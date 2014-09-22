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
    echo "HTTP_PROXY=$HTTP_PROXY" >> /etc/environment
    echo "HTTPS_PROXY=$HTTP_PROXY" >> /etc/environment
    echo "FTP_PROXY=$HTTP_PROXY" >> /etc/environment
    # apt: overwrite real proxy with cntlm settings..
    echo "Acquire::http::Proxy \"$HTTP_PROXY\";" > /etc/apt/apt.conf.d/01proxy;
    echo "Acquire::https::Proxy \"$HTTP_PROXY\";" >> /etc/apt/apt.conf.d/01proxy;
}

if [ -f /vagrant/proxy_settings.conf ]
then
    echo "found proxy_settings, installing cntlm"
    installCntlm
    reconfigureEnvForCntlm
fi
