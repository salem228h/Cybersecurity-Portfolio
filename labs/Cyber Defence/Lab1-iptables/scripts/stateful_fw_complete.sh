#!/bin/bash
# Firewall Script: Complete Stateful Firewall Configuration
# Purpose: Enhanced stateful firewall with loopback, INVALID drop, and automatic flush
# Author: Cybersecurity Lab
# Date: November 2025

# Flush all tables and delete custom chains
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

echo "=== Complete Stateful Firewall Configuration Applied ==="
echo ""
echo "INPUT Chain (Detailed View):"
iptables -L INPUT -v -n --line-numbers
echo ""
echo "OUTPUT Chain:"
iptables -L OUTPUT -v -n --line-numbers
echo ""
echo "FORWARD Chain:"
iptables -L FORWARD -v -n --line-numbers
