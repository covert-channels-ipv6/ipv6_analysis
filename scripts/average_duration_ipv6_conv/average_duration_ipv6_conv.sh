#!/bin/bash

for var in "$@"; do

	echo "File: ${var}"

	min=0
	max=0
	result=0

	ipv6_conv=`tshark -nr $var -q -z conv,ipv6`
	
	# Starting at line 6 (jump over the table description)
	duration_per_conv=`echo "$ipv6_conv" | awk 'BEGIN{}{printf "%s\n", $11}END{}' | tail -n +6 | tr , .`
	number_of_ipv6_conversations=`echo "$duration_per_conv" | wc -l`

	for x in `echo "$duration_per_conv"`; do

		result=$(echo "scale=4; $result+$x" | bc -l)

 		if (( $(echo "$x < $min" | bc -l) )); then
 			min=$(echo "scale=4; $x" | bc -l)
 		fi

 		if (( $(echo "$x > $max" | bc -l) )); then
 			max=$(echo "scale=4; $x" | bc -l)
 		fi

	done

	average_duration_per_conversation=$(echo "scale=4; $result/$number_of_ipv6_conversations" | bc)

	echo "Number of IPv6 Conversations: $number_of_ipv6_conversations"
	echo "Minimum Duration/Conversation: $min"
	echo "Maximum Duration/Conversation: $max"
	echo "Average Duration/Conversation: $average_duration_per_conversation"
	echo ""

done
