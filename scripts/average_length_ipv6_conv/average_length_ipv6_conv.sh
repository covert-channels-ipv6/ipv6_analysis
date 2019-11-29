#!/bin/bash

for var in "$@"; do

	echo "File: ${var}"

	min=0
	max=0
	result=0

	ipv6_conv=`tshark -nr $var -q -z conv,ipv6`
	
	# Starting at line 6 (jump over the table description)
	total_length_per_conv=`echo "$ipv6_conv" | awk 'BEGIN{}{printf "%s\n", $9}END{}' | tail -n +6`
	number_of_ipv6_conversations=`echo "$total_length_per_conv" | wc -l`

	for x in `echo "$total_length_per_conv"`; do

		result=$(($result+$x))

 		if [ "$(($x))" -lt "$min" ]; then
 			min="$(($x))"
 		fi

 		if [ "$(($x))" -gt "$max" ]; then
 			max="$(($x))"
 		fi

	done

	average_length_per_conversation=$(echo "scale=2; $result/$number_of_ipv6_conversations" | bc)

	echo "Number of IPv6 Conversations: $number_of_ipv6_conversations"
	echo "Minimum Length/Conversation (Bytes): $min"
	echo "Maximum Length/Conversation (Bytes): $max"
	echo "Average Length/Conversation (Bytes): $average_length_per_conversation"
	echo ""

done
