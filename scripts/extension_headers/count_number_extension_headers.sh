#!/bin/bash

echo "Explanation:"
echo "Typ 0:  Hop-by-Hop Header ID"
echo "Typ 43: Routing Header ID"
echo "Typ 44: Fragment Header ID"
echo "Typ 60: Destination Header ID"
echo "Typ 51: Authentication Header ID"
echo "Typ 50: Encapsulation Header ID"
echo "Output: Number of found Extension Header | ID of Extension Headers"
echo ""

for var in "$@"; do
	echo "File: ${var}"
	output_all=`tshark -nr $var -T fields -e ipv6.version -Y "ipv6"`

	output_extension_headers=`tshark -nr $var -T fields -e ipv6.nxt -Y "ipv6.nxt == 0 || ipv6.nxt == 43 || ipv6.nxt == 44 || ipv6.nxt == 60 || ipv6.nxt == 51 || ipv6.nxt == 50" | sort -n | uniq -c`

	number_all_packets=`echo "${output_all}" | wc -l`
	
	echo "Analyzed Packets: ${number_all_packets}"
	
	while read -r line; do
	 	IFS=' ' read -ra ADDR <<< "$line"
	 	buf=${ADDR[0]}
		amount_eh=$(echo "scale=4; $buf/$number_all_packets" | bc)
		amount_eh=$(echo "scale=4; $amount_eh*100" | bc)
	 	echo "${ADDR[0]} ${ADDR[1]} (${amount_eh}%)"
	done <<< "$output_extension_headers"

	echo ""
	
done