#!/bin/bash
source ./scan_lib

#nmap scanme.nmap.org
#/PATH/TO/dirsearch.py -u scanme.nmap.org -e php

# Get options
getopts "m:" OPTION
MODE=$OPTARG

while getops "m:i" OPTION; do
  case "$OPTION" in
    m)
      MODE=${OPTARG}
      ;;
    i)
      INTERACTIVE=true
      ;;
  esac
done

# shellcheck disable=SC1009
scan_domain() {
  DOMAIN="${1}"
  DIRECTORY="${DOMAIN}_recon"
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
}

report_domain() {
  DOMAIN="${1}"
  DIRECTORY="${DOMAIN}_recon"
  echo "Generating recon report ${DOMAIN}..."
    if [ -f "${DIRECTORY}"/nmap ]; then
      echo "Nmap scan results:" >> "${DIRECTORY}"/report
      grep -E "^\s*\S+\s+\S+\s+\S+\s*$" "${DIRECTORY}/nmap" >> "${DIRECTORY}/report"
    fi
    if [ -f "${DIRECTORY}"/dirsearch ]; then
      echo "Dirsearch results:" >> "${DIRECTORY}/report"
      cat "${DIRECTORY}/dirsearch" >> "${DIRECTORY}/report"
    fi
    if [ -f "${DIRECTORY}"/crt ]; then
      echo "Cert parsing results:" >> "${DIRECTORY}/report"
      jq -r ".[] | .name_value" "${DIRECTORY}/crt" >> "${DIRECTORY}/report"
    fi
}
if [ "${INTERACTIVE}" ]; then
  INPUT="BLANK"
  while [ "${INPUT}" != "q" ]; do
    echo "Enter a domain to scan or q to quit:"
    read -r INPUT
    if [ "${INPUT}" != "q" ]; then
      scan_domain "${INPUT}"
      report_domain "${INPUT}"
    fi
  done
else
  for i in "${@:$OPTIND:$#}"; do
    scan_domain "${i}"
    report_domain "${i}"
  done
fi
