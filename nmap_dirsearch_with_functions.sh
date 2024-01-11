#!/bin/bash

#nmap scanme.nmap.org
#/PATH/TO/dirsearch.py -u scanme.nmap.org -e php

# Using functions
TODAY=$(date)
echo "This scan was created ${TODAY}"
DOMAIN=$1
DIRECTORY=${DOMAIN}_recon


echo "Creating directory for $DIRECTORY."
mkdir "$DIRECTORY"

nmap_scan() {
  nmap "$DOMAIN" > "$DIRECTORY"/nmap
  echo "The results of nmap scan are stored in $DIRECTORY/nmap."
}

dirsearch_scan() {
  dirsearch.py -u "$DOMAIN" -e php --simple-report="$DIRECTORY"/dirsearch
  echo "The results of dirsearch are stored in $DIRECTORY/dirsearch."
}

ctr_scan() {
  curl "https://crt.sh/?q=${DOMAIN}&output=json" -o "$DIRECTORY"/crt
  echo "The results of cert parsing is stored in $DIRECTORY/crt"
}

case $2 in
  nmap-only)
    nmap_scan
    ;;
  dirsearch-only)
    dirsearch_scan
    ;;
  crt-only)
    ctr_scan
    ;;
  *)
    nmap_scan
    dirsearch_scan
    ctr_scan
    ;;
esac
