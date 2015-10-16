#!/bin/bash

# Set up your StartSSL certificates/keys for nginx-proxy
# This script expects your certificate and key files in this folder following
# the nginx-proxy naming convention.
# For example: foo.example.com.crt foo.example.com.key
# are the .crt and .key file for the domain foo.example.com

# Make sure script is ran from correct directory
if [[ ! -e script.sh ]]; then
    if [[ -d certs ]]; then
        cd certs || { echo >&2 "Bundle directory exists but I can't cd there."; exit 1; }
    else
        echo >&2 "Please cd into the bundle before running this script."; exit 1;
    fi
fi

CERT_CLASS="class1"
CERT_CA_FILE="sub.${CERT_CLASS}.server.ca.pem"
DHPARAM_FILE="dhparam.pem"

# Get the StartSSL Root CA and Class 1 Intermediate Server CA certificates
if [ ! -f ${CERT_CA_FILE} ]; then
  wget https://www.startssl.com/certs/${CERT_CA_FILE}
fi

# Generate dhparam.pem if needed.
if [ ! -f ${DHPARAM_FILE} ]; then
  echo "${DHPARAM_FILE} not found."
  echo "Generating ${DHPARAM_FILE} with openssl"
  openssl dhparam -out ${DHPARAM_FILE} 2048
fi


# Create a private key and certificate and transfer them to your server.
for file in *.key; do
  DOMAIN=${file%.*}

  if [ ! -f ./unified/${DOMAIN}.crt ]; then

    echo "DHPARAM: Copying ${DOMAIN}.${DHPARAM_FILE}"
    cp ./${DHPARAM_FILE} ./unified/${DOMAIN}.${DHPARAM_FILE}

    echo "CRT: Creating unified ${DOMAIN}.crt"
    cat ./${DOMAIN}.crt ${CERT_CA_FILE} > ./unified/${DOMAIN}.crt

    # Keys should already be decrypted
    echo "KEY: Copying ${DOMAIN}.key"
    cp ./${DOMAIN}.key ./unified/${DOMAIN}.key

    echo ""
  fi

  # Protect your key files from prying eyes
  chmod 600 ./${DOMAIN}.key
  chmod 600 ./unified/${DOMAIN}.key

done
