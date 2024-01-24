#!/bin/bash
source ./scan_lib

#nmap scanme.nmap.org
#/PATH/TO/dirsearch.py -u scanme.nmap.org -e php

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


