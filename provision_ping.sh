#!/bin/bash

# Define an array with the private IP addresses of all VMs
declare -a ips=("$@")

# Get the current VM's private IP address
current_ip="${ips[0]}"

# Get the number of VMs
num_vms=${#ips[@]}

# Perform ping in a round-robin fashion
for ((i=1; i<$num_vms; i++)); do
    target_ip="${ips[$i]}"
    ping_result=$(ping -c 1 "$target_ip" | grep -oP "(?<=time=)[^ ]+" || echo "Fail")
    echo "Ping from $current_ip to $target_ip: $ping_result"
done
