#!/bin/bash

#nmap scanme.nmap.org
#/PATH/TO/dirsearch.py -u scanme.nmap.org -e php

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

# Get options
getopts "m:" OPTION
MODE=$OPTARG

for i in "${@:$OPTIND:$#}"
do
  # Using functions
  TODAY=$(date)
  echo "This scan was created ${TODAY}"
  DOMAIN=$i
  DIRECTORY=${DOMAIN}_recon

  echo "Creating directory for $DIRECTORY."
  mkdir "$DIRECTORY"

  case $MODE in
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

  echo "Generating recon report from output files..."
    if [ -f "${DIRECTORY}"/nmap ]; then
      echo "Nmap scan results:" > "${DIRECTORY}"/report
      grep -E "^\s*\S+\s+\S+\s+\S+\s*$" "${DIRECTORY}/nmap" >> "${DIRECTORY}/report"
    fi
    if [ -f "${DIRECTORY}"/dirsearch ]; then
      echo "Dirsearch results:" >> "${DIRECTORY}"/report
      cat "${DIRECTORY}/dirsearch" >> "${DIRECTORY}/report"
    fi
    if [ -f "${DIRECTORY}"/crt ]; then
      echo "Cert parsing results:" >> "${DIRECTORY}/report"
      jq -r ".[] | .name_value" "${DIRECTORY}/crt" >> "${DIRECTORY}/report"
    fi
done
