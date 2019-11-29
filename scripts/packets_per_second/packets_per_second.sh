#!/bin/bash

for var in "$@"; do

	echo "File: ${var}"

	output_frame_time_relative=`tshark -nr $var -T fields -e frame.time_relative -Y "ipv6"`
	seconds=`echo "$output_frame_time_relative" | sort -n | tail -1`
	number_of_frames=`echo "$output_frame_time_relative" | wc -l`

	packets_per_second=$(echo "scale=9; $number_of_frames/$seconds" | bc)

	echo "Number of IPv6-Packets: $number_of_frames"
	echo "Seconds: $seconds"
	echo "Packets/Second: $packets_per_second"

done