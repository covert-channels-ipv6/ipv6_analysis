#!/bin/bash

for var in "$@"; do

	echo "File: $var"
	echo "Topic / Item       Count         Average       Min val       Max val       Rate (ms)     Percent       Burst rate    Burst start"
	tshark -r $var -qz plen,tree | egrep 'Packet Lengths '
	echo ""

done
