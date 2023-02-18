#! /usr/bin/bash 

apt-get install openssl openvpn ca-certificates easy-rsa
wget -qO- https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.8/EasyRSA-3.0.8.tgz 2>/dev/null | tar xz  -C /etc/openvpn/server/easy-rsa/ --strip-components 1
cd /etc/openvpn/server/easy-rsa
sudo chown -R root:root /etc/openvpn/server/easy-rsa
./easyrsa init-pki
./easyrsa --batch build-ca
EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-server-full server nopass
EASYRSA_CERT_EXPIRE=3650 ./easyrsa gen-crl
openssl dhparam -out pki/dh.pem 2048
openvpn --genkey --secret pki/tc.key
cp pki/ca.crt  pki/private/ca.key pki/private/server.key  pki/issued/server.crt pki/dh.pem  pki/crl.pem  pki/tc.key  server/
cp server/* ../
echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/99-openvpn-forward.conf
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl --system
systemctl enable openvpn-server@server.service
systemctl start openvpn-server@server.service
