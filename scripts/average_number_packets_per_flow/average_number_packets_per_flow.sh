#!/bin/bash

all_flow_packets=0
different_flows=0
min=0
max=0

for var in "$@"; do

	echo "File: ${var}"
	
	output_all=`tshark -nr $var -T fields -e ipv6.version -Y "ipv6"`
	output_flow=`tshark -nr $var -T fields -e ipv6.flow -e ipv6.src -e ipv6.dst -Y "ipv6.flow != 0" | sort | uniq -c`
	
	number_all_packets=`echo "${output_all}" | wc -l`
	different_flows=`echo "${output_flow}" | wc -l`	
	
	while read -r line; do
	 	IFS=' ' read -ra ADDR <<< "$line"
	 	all_flow_packets="$((all_flow_packets+${ADDR[0]}))"

	 	if [ "$min" -eq 0 ]; then
	 		min="$((${ADDR[0]}))"
	 	else
	 		if [ "$((${ADDR[0]}))" -lt "$min" ]; then
	 			min="$((${ADDR[0]}))"
	 		fi
	 	fi

	 	if [ "$max" -eq 0 ]; then
	 		max="$((${ADDR[0]}))"
	 	else
	 		if [ "$((${ADDR[0]}))" -gt "$max" ]; then
	 			max="$((${ADDR[0]}))"
	 		fi
	 	fi

	done <<< "$output_flow"
	
	amount_flow_packets=$(echo "scale=4; $all_flow_packets/$number_all_packets" | bc)
	amount_different_flows=$(echo "scale=4; $different_flows/$number_all_packets" | bc)

	amount_flow_packets=$(echo "scale=4; $amount_flow_packets*100" | bc)
	amount_different_flows=$(echo "scale=4; $amount_different_flows*100" | bc)

	buf_packets_per_flow=$(echo "scale=2; $all_flow_packets/$different_flows" | bc)
	
	echo "Analyzed Packets: ${number_all_packets}"
	echo "Amount of Flow-Packets: ${all_flow_packets} (${amount_flow_packets}%)"
	echo "Amount of different Flows: ${different_flows} (${amount_different_flows}%)"
	echo "Minimum Number Packets/Flow: ${min}"
	echo "Maximum Number Packets/Flow: ${max}"
	echo "Average Number Packets/Flow: ${buf_packets_per_flow}"
	echo ""

	all_flow_packets=0
	min=0
	max=0

done
