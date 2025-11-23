#!/bin/bash
# Firewall Script: MAC Address Whitelist Configuration
# Purpose: Allow only 5 trusted hosts based on MAC addresses
# Author: Cybersecurity Lab
# Date: November 2025

# Flush INPUT chain
iptables -F

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT

# Array of trusted MAC addresses
# Modify these MAC addresses to match your trusted devices
TRUSTED_MACS=(
    "b4:6d:83:77:85:f1"
    "b4:6d:83:77:85:f2"
    "b4:6d:83:77:85:f3"
    "b4:6d:83:77:85:f4"
    "b4:6d:83:77:85:f5"
)

# Allow 5 trusted MACs
for mac in "${TRUSTED_MACS[@]}"
do
    iptables -A INPUT -m mac --mac-source "$mac" -j ACCEPT
done

# Drop all other traffic
iptables -A INPUT -j DROP

echo "=== MAC Whitelist Firewall Configuration Applied ==="
echo ""
echo "Trusted MAC Addresses:"
for mac in "${TRUSTED_MACS[@]}"
do
    echo "  ✓ $mac"
done
echo ""
echo "INPUT Chain (Verification):"
iptables -L INPUT -v -n --line-numbers
echo ""
echo "Rules Applied: $(iptables -L INPUT -n | grep -c 'ACCEPT'|'DROP') total"
