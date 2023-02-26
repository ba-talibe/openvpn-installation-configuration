#! /usr/bin/bash 

export HOST=54.157.181.139
export PORT=1194

apt-get install openssl openvpn ca-certificates easy-rsa
mkdir /etc/openvpn/server/easy-rsa/
wget -qO- https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.8/EasyRSA-3.0.8.tgz 2>/dev/null | tar xz  -C /etc/openvpn/server/easy-rsa/ --strip-components 1
cd /etc/openvpn/server/easy-rsa
sudo chown -R root:root /etc/openvpn/server/easy-rsa
./easyrsa init-pki
./easyrsa --batch build-ca
EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-server-full server nopass
EASYRSA_CERT_EXPIRE=3650 ./easyrsa gen-crl
openssl dhparam -out pki/dh.pem 2048
openvpn --genkey --secret pki/tc.key

echo "local $HOST" >> server.conf
echo "port $PORT" >> server.conf
echo "proto tcp" >> server.conf
echo "dev tun" >> server.conf
echo "ca ca.crt" >> server.conf
echo "cert server.crt" >> server.conf
echo "key server.key" >> server.conf
echo "dh dh.pem" >> server.conf
echo "tls-crypt tc.key" >> server.conf
echo "crl-verify crl.pem" >> server.conf
echo "auth SHA512" >> server.conf
echo "topology subnet" >> server.conf
echo "server 10.8.0.0 255.255.0.0" >> server.conf
echo "client-conf-dir /etc/openvpn/ccd" >> server.conf
echo "route 10.10.40.0 255.255.255.0" >> server.conf
echo ";push "route 10.10.40.0 255.255.255.0"" >> server.conf
echo "push "redirect-gateway def1"" >> server.conf
echo "keepalive 10 120" >> server.conf
echo "cipher AES-256-GCM" >> server.conf
echo "user nobody" >> server.conf
echo "group nogroup" >> server.conf
echo "persist-key" >> server.conf
echo "persist-tun" >> server.conf
echo "verb 3" >> server.conf
echo "status /var/log/openvpn/openvpn-status.log" >> server.conf" >> server.conf
echo "log-append /var/log/openvpn/openvpn.log" >> server.conf

cp pki/ca.crt  pki/private/ca.key pki/private/server.key  pki/issued/server.crt pki/dh.pem  pki/crl.pem  pki/tc.key  server/
cp server/* ../
echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/99-openvpn-forward.conf
echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl --system
systemctl enable openvpn-server@server.service
systemctl stop openvpn-server@server.service
systemctl start openvpn-server@server.service
