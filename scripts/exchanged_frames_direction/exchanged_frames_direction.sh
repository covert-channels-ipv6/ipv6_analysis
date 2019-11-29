#!/bin/bash

for var in "$@"; do

	echo "File: ${var}"

	min_left=0
	max_left=0

	min_right=0
	max_right=0
	
	# contains all exchanged frames to A
	result_left=0
	# contains all exchanged frames to B
	result_right=0

	ipv6_conv=`tshark -nr $var -q -z conv,ipv6`
	
	# Starting at line 6 (jump over the table description)
	
	# "<- or A"
	exchanged_frames_left=`echo "$ipv6_conv" | awk 'BEGIN{}{printf "%s\n", $4}END{}' | tail -n +6`
	# "-> or B"
	exchanged_frames_right=`echo "$ipv6_conv" | awk 'BEGIN{}{printf "%s\n", $6}END{}' | tail -n +6`
	
	number_of_ipv6_conversations=`echo "$exchanged_frames_left" | wc -l`

	for x in `echo "$exchanged_frames_left"`; do

		result_left=$(($result_left+$x))

 		if [ "$(($x))" -lt "$min_left" ]; then
 			min_left="$(($x))"
 		fi

 		if [ "$((x))" -gt "$max_left" ]; then
 			max_left="$(($x))"
 		fi

	done

	for x in `echo "$exchanged_frames_right"`; do

		result_right=$(($result_right+$x))

 		if [ "$(($x))" -lt "$min_right" ]; then
 			min_right="$(($x))"
 		fi

 		if [ "$((x))" -gt "$max_right" ]; then
 			max_right="$(($x))"
 		fi

	done

	average_exchanged_packets_left=$(echo "scale=4; $result_left/$number_of_ipv6_conversations" | bc)
	average_exchanged_packets_right=$(echo "scale=4; $result_right/$number_of_ipv6_conversations" | bc)

	echo "Number of IPv6 Conversations: $number_of_ipv6_conversations"
	echo "Sum Packets Left (<-): $result_left"
	echo "Minimum Packets Left (<-): $min_left"
	echo "Maximum Packets Left (<-): $max_left"
	echo "Average Packets Left(<-): $average_exchanged_packets_left"
	echo "Sum Packets Right (->): $result_right"
	echo "Minimum Packets Right (->): $min_right"
	echo "Maximum Packets Right (->): $max_right"
	echo "Average Packets Right(->): $average_exchanged_packets_right"
	echo ""

done
