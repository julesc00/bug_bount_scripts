#!/bin/bash

#nmap scanme.nmap.org
#/PATH/TO/dirsearch.py -u scanme.nmap.org -e php

# Better version with arguments
TODAY=$(date)
echo "This scan was created ${TODAY}"
DOMAIN=$1
DIRECTORY=${DOMAIN}_recon


echo "Creating directory for $DIRECTORY."
mkdir "$DIRECTORY"
if [ "$2" == "nmap-only" ]
then
  nmap "$DOMAIN" > "$DIRECTORY"/nmap
  echo "The results of nmap scan are stored in $DIRECTORY/nmap."
elif [ "$2" == "dirsearch-only" ]
then
  dirsearch.py -u "$DOMAIN" -e php --simple-report="$DIRECTORY"/dirsearch
  echo "The results of dirsearch are stored in $DIRECTORY/dirsearch."
else
  # Run both nmap and dirsearch
  nmap "$DOMAIN" > "$DIRECTORY"/nmap
  echo "The results of nmap scan are stored in $DIRECTORY/nmap."
  dirsearch.py -u "$DOMAIN" -e php --simple-report="$DIRECTORY"/dirsearch
  echo "The results of dirsearch are stored in $DIRECTORY/dirsearch."
fi
