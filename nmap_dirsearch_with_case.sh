#!/bin/bash

#nmap scanme.nmap.org
#/PATH/TO/dirsearch.py -u scanme.nmap.org -e php

# Using case
TODAY=$(date)
echo "This scan was created ${TODAY}"
DOMAIN=$1
DIRECTORY=${DOMAIN}_recon

case $2 in
  nmap-only)
    nmap "$DOMAIN" > "$DIRECTORY"/nmap
    echo "The results of nmap scan are stored in ${DIRECTORY}/nmap."
    ;;
  dirsearch-only)
    dirsearch.py -u "$DOMAIN" -e php --simple-report="$DIRECTORY"/dirsearch
    echo "The results of dirsearch scan are stored in ${DIRECTORY}/dirsearch."
    ;;
  crt-only)
    curl "https://crt.sh/?q=${DOMAIN}&output=json" -o "$DIRECTORY"/crt
    echo "The results of cert parsing is stored in ${DIRECTORY}/crt"
    ;;
  *)
    nmap "$DOMAIN" > "$DIRECTORY"/nmap
    echo "The results of nmap scan are stored in ${DIRECTORY}/nmap."
    curl "https://crt.sh/?q=${DOMAIN}&output=json" -o "$DIRECTORY"/crt
    ;;
esac
