#!/bin/bash

for var in "$@"; do

	echo "File: ${var}"
	tshark -r $var -Y "ipv6.flow!=0" -w "$var.buf"
	echo "Topic / Item       Count         Average       Min val       Max val       Rate (ms)     Percent       Burst rate    Burst start"
	tshark -r "$var.buf" -qz plen,tree | egrep 'Packet Lengths '
	rm "$var.buf"
	echo ""

done
