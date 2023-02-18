#! /usr/bin/bash
export P="0"

if [ "$1" == '' ] ; then
	export P="1"
fi
if [ "$P" -eq "1" ];then
	echo "syntax :"
    echo "        ./create_client_cert.sh [client_name]"
    echo "make sure the script is executable :-)"
    echo "happy hacks"
    exit
fi


mkdir $1
EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-client-full $1 nopass || echo "An error occurs" && exit
cp pki/ca.crt  pki/private/ca.key pki/private/$1.key  pki/issued/$1.crt pki/dh.pem pki/crl.pem  pki/tc.key $1/
tar -cvf $1.tar $1/
zip $1/ 
echo "A zip archive file is generated for windows clients"