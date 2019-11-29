#!/bin/bash

for var in "$@"; do

	echo "File: ${var}"

	min=1
	max=1
	result=0

	ipv6_conv=`tshark -nr $var -q -z conv,ipv6`
	
	# Starting at line 6 (jump over the table description)
	packets_per_conv=`echo "$ipv6_conv" | awk 'BEGIN{}{printf "%s\n", $8}END{}' | tail -n +6`
	number_of_ipv6_conversations=`echo "$packets_per_conv" | wc -l`

	for x in `echo "$packets_per_conv"`; do

		result=$(($result+$x))

 		if [ "$(($x))" -lt "$min" ]; then
 			min="$(($x))"
 		fi

 		if [ "$(($x))" -gt "$max" ]; then
 			max="$(($x))"
 		fi

	done

	average_packet_number_per_conversation=$(echo "scale=2; $result/$number_of_ipv6_conversations" | bc)

	echo "Number of IPv6 Conversations: $number_of_ipv6_conversations"
	echo "Minimum Packet Number/Conversation: $min"
	echo "Maximum Packet Number/Conversation: $max"
	echo "Average Packet Number/Conversation: $average_packet_number_per_conversation"
	echo ""

done
