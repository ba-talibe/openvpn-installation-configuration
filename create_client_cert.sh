#! /usr/bin/bash

mkdir $1
EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-client-full $1 nopass || echo "An error occurs" && exit
cp pki/ca.crt  pki/private/ca.key pki/private/$1.key  pki/issued/$1.crt pki/dh.pem pki/crl.pem  pki/tc.key $1/
tar -cvf $1.tar $1/