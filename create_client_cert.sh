export P="0"

if [ "$1" == '' ] ; then
	export P="1"
fi
if [ "$P" -eq "1" ];then
	echo "syntax :"
    echo "        ./create_client_cert.sh [client_name]"
    echo "to create zip archive for windows client"
    echo "        ./create_client_cert.sh [client_name] win"
    echo "make sure the script is executable :-)"
    echo "happy hacks"
    exit
fi


mkdir $1
EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-client-full $1 nopass && \
cp pki/ca.crt  pki/private/ca.key pki/private/$1.key  pki/issued/$1.crt pki/dh.pem pki/crl.pem  pki/tc.key $1/ && \
if [ "$2" == "" ]
    tar -cvf $1.tar $1/ || echo "An error occurs while generating PEM et CRT files" && exit
else
    zip $1/
fi
