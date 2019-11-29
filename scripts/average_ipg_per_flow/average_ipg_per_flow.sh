#!/bin/bash

for var in "$@"; do

	echo "File: ${var}"

	output_different_flows=`tshark -nr $var -T fields -e ipv6.flow -e ipv6.src -e ipv6.dst -Y "ipv6.flow != 0" | sort | uniq`
	min_gap=0
	max_gap=0
	sum_gaps=0
	number_gaps_complete=0
	average_ipg=0


	while read -r line; do
	 	IFS=' ' read -ra ADDR <<< "$line"
	 	while read -r line2; do
	 		IFS2='	' read -ra ADDR2 <<< "$line2"
	 		
	 		flow_label="${ADDR2[0]}"
	 		src="${ADDR2[1]}"
	 		dst="${ADDR2[2]}"
	 		
	 		frame_times_of_flow=`tshark -nr $var -T fields -e frame.time_delta_displayed -Y "ipv6.flow == $flow_label && ipv6.src == $src && ipv6.dst == $dst"`
	 		number_of_flow_packets=`echo "$frame_times_of_flow" | wc -l`

	 		# Gaps can be determined
	 		if (( $(echo "$number_of_flow_packets > 1" | bc -l) )); then
	 			# Get all Intergap Times
	 			for val in `echo "$frame_times_of_flow"`; do
	 				# Omit the first Value, because it is always 0
	 				if (( $(echo "$val > 0" | bc -l) )); then

	 					# Necessary???
	 					# if (( $(echo "min_gap == 0" | bc -l) )); then
	 					# 	min_gap=$(echo "scale=9; $val" | bc)
	 					# else
	 					# 	if (( $(echo "$val < $min_gap" | bc -l) )); then
	 					# 		min_gap=$(echo "scale=9; $val" | bc)
	 					# 	fi
	 					# fi

	 					# if (( $(echo "max_gap == 0" | bc -l) )); then
	 					# 	max_gap=$(echo "scale=9; $val" | bc)
	 					# else
	 					# 	if (( $(echo "$val > $max_gap" | bc -l) )); then
	 					# 		max_gap=$(echo "scale=9; $val" | bc)
	 					# 	fi
	 					# fi

	 					sum_gaps=$(echo "scale=9; $sum_gaps+$val" | bc)
	 					number_gaps_complete=$(($number_gaps_complete+1))
	 				fi
	 			done
	 		fi

	 	done <<< "${ADDR[0]}"
	done <<< "$output_different_flows"

	average_ipg=$(echo "scale=9; $sum_gaps/$number_gaps_complete" | bc)
	
	echo "Sum of IPG in Flows: $sum_gaps"
	echo "Number of IPG: $number_gaps_complete"
	echo "Average IPG-Length in Flows: $average_ipg"
	echo ""

done
