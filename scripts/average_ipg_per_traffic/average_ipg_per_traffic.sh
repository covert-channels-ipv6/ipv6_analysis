#!/bin/bash

for var in "$@"; do

	
	echo "File: ${var}"

	output_time_delta=`tshark -nr $var -T fields -e frame.time_delta_displayed -Y "ipv6"`
	
	# First frame will always contain 0.000000000, so taking the second frame
	min=`echo "$output_time_delta" | sort -n | head -2 | tail -1`
	max=`echo "$output_time_delta" | sort -n | tail -1`
	
	echo "Minimal IPG: $min" 
	echo "Maximimal IPG: $max" 
	echo "$output_time_delta" | awk 'BEGIN  {
												sum_ipg=0;
												number_packets=0;
											}
											{
												sum_ipg+=$1;
												number_packets+=1;
											}
									END 	{
												printf "Time since first frame: %.9f\n", sum_ipg;
												printf "Number of Packets: %.0f\n", number_packets;
												printf "Average IPG: %.9f\n", sum_ipg/(number_packets-1);
											}'
	echo ""

done
