#!/bin/bash

echo "Setup started" >> /debug1.txt

echo "Setting up Envirnment variables" >> /debug1.txt
set -e
export HOSTNAME="${domain_name}"
export EMAIL="${email_address}"
ADMIN_USER="${admin_username}"
ADMIN_PASSWORD="${admin_password}"

echo "Setup started" >> /debug1.txt

echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" >> /etc/resolv.conf

# disable ipv6
echo "disable ipv6" >> /debug1.txt
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
echo "ipv6 diabled" >> /debug1.txt

# set hostname
echo "set hostname" >> /debug1.txt
hostnamectl set-hostname $HOSTNAME
echo -e "127.0.0.1 localhost $HOSTNAME" >> /etc/hosts
apt update
echo "hostname is set" >> /debug1.txt


# install Java
echo "install Java" >> /debug1.txt
apt install -y openjdk-8-jre-headless
echo "JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")" | sudo tee -a /etc/profile
source /etc/profile
echo "Java Installed" >> /debug1.txt

# install NGINX
echo "install NGINX" >> /debug1.txt
apt install -y nginx
systemctl start nginx.service
systemctl enable nginx.service
echo "NGINX installed " >> /debug1.txt

# add Prosody Package to sources
echo "add Prosody Package to sources" >> /debug1.txt
curl -sL https://prosody.im/files/prosody-debian-packages.key | sudo tee /etc/apt/keyrings/prosody-debian-packages.key
echo "deb [signed-by=/etc/apt/keyrings/prosody-debian-packages.key] http://packages.prosody.im/debian $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/prosody-debian-packages.list
apt install lua5.2
echo "added Prosody Package to sources" >> /debug1.txt

# add Jitsi to sources
echo "add Jitsi to sources" >> /debug1.txt
curl -sL https://download.jitsi.org/jitsi-key.gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/jitsi-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/" | sudo tee /etc/apt/sources.list.d/jitsi-stable.list
echo "added Jitsi to source completed" >> /debug1.txt


# Configure Jits install
echo "Configure Jits install" >> /debug1.txt
debconf-set-selections <<< $(echo 'jitsi-videobridge jitsi-videobridge/jvb-hostname string '$HOSTNAME)
debconf-set-selections <<< 'jitsi-meet-web-config   jitsi-meet/cert-choice  select  "Generate a new self-signed certificate"';
echo "Jitsi Configuration installed" >> /debug1.txt

# Debug
echo "Debug" >> /debug1.txt
echo $EMAIL >> /debug1.txt
echo $HOSTNAME >> /debug1.txt
cat /etc/resolv.conf >> /debug1.txt
whoami >> /debug1.txt
cat /etc/hosts >> /debug1.txt
echo "Debuging completed" >> /debug1.txt


# Install Jitsi
echo "Install Jitsi" >> /debug1.txt
apt-get -y update
apt-get -y install jitsi-meet
echo "Jitsi installation completed" >> /debug1.txt

# letsencrypt
echo "letsencrypt" >> /debug1.txt
echo $EMAIL | /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh >> /debug1.txt


PROSODY_CONF_FILE=/etc/prosody/conf.d/$HOSTNAME.cfg.lua
sed -e 's/authentication \= "anonymous"/authentication \= "internal_plain"/' -i $PROSODY_CONF_FILE
echo >> $PROSODY_CONF_FILE
echo "VirtualHost \"guest.$HOSTNAME\"" >> $PROSODY_CONF_FILE
echo "    authentication = \"anonymous\"" >> $PROSODY_CONF_FILE
echo "    allow_empty_token = true" >> $PROSODY_CONF_FILE
echo "    c2s_require_encryption = false" >> $PROSODY_CONF_FILE

sed -e "s/\/\/ anonymousdomain: .*$/anonymousdomain: 'guest.$HOSTNAME',/" -i /etc/jitsi/meet/$HOSTNAME-config.js

echo "org.jitsi.jicofo.auth.URL=XMPP:$HOSTNAME" >> /etc/jitsi/jicofo/sip-communicator.properties
echo "letsencrypt & Prosody and Org started" >> /debug1.txt

# Enable local STUN server
echo "Enable local STUN server" >> /debug1.txt
sed -e "s/org\.ice4j\.ice\.harvest\.STUN_MAPPING_HARVESTER_ADDRESSES=.*/org.ice4j.ice.harvest.STUN_MAPPING_HARVESTER_ADDRESSES=$HOSTNAME:5349/" -i /etc/jitsi/videobridge/sip-communicator.properties

echo "Enabling Moderator credentials for $ADMIN_USER" >> /debug1.txt
prosodyctl --config /etc/prosody/prosody.cfg.lua register $ADMIN_USER $HOSTNAME $ADMIN_PASSWORD

${jibri_installation_script}

prosodyctl restart &>> /debug1.txt
/etc/init.d/jitsi-videobridge2 restart &>> /debug1.txt
/etc/init.d/jicofo restart &>> /debug1.txt

echo "Setup completed" >> /debug1.txt
echo "Enable local STUN server completed" >> /debug1.txt
${reboot_script}