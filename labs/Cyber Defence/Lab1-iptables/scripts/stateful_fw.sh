#!/bin/bash
# Firewall Script: Basic Stateful Firewall Configuration
# Purpose: Configure a basic stateful firewall for a laptop
# Author: Cybersecurity Lab
# Date: November 2025

# Flush all chains
iptables -F
iptables -X

# Set default policies
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

# Allow loopback traffic
iptables -A INPUT -i lo -j ACCEPT

# Drop INVALID packets explicitly
iptables -A INPUT -m state --state INVALID -j DROP

# Allow established and related connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

echo "=== Basic Stateful Firewall Configuration Applied ==="
echo ""
echo "INPUT Chain (showing stateful rules):"
iptables -L INPUT -v -n --line-numbers
echo ""
echo "OUTPUT Chain:"
iptables -L OUTPUT -v -n --line-numbers
