#!/bin/bash

echo "Script looks for nxt field in Fragment Extension Headers"
echo ""

for var in "$@"; do
	echo "File: ${var}"

	output_fragheader_nxt=`tshark -nr $var -T fields -e ipv6.fraghdr.nxt -Y "ipv6.fraghdr" | sort -n | uniq -c`

	while read -r line; do
	 	IFS=' ' read -ra ADDR <<< "$line"
	 	echo "${ADDR[0]} ${ADDR[1]}"
	done <<< "$output_fragheader_nxt"

	echo ""

done