# Lab #1: iptables Configuration - Complete Documentation

## Overview

This document contains the complete lab submission for configuring Linux iptables firewall rules. The lab is organized into four parts covering fundamental firewall concepts through advanced Network Address Translation.

---

## Part 1: The iptables Command

### Stage 1: Setup and Initial Screenshots

**Objective:** Prepare the Router VM and capture initial system state.

#### Step 1: Login and Root Access
```bash
sudo su
```

#### Step 2: Check Initial iptables Status
```bash
iptables -L -v -n
```
**Expected Output:** Empty firewall with default policies

#### Step 3: Verify IP Addresses and Interfaces
```bash
ip addr
```
**Expected Output:**
- enp0s3 → WAN interface
- enp0s8 → LAN interface (10.0.2.1)

---

### Stage 2: Challenge #1 - Default Policies

**Objective:** Set default POLICY to ACCEPT on INPUT and OUTPUT chains, and DROP on FORWARD chain.

```bash
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD DROP
```

**Explanation:**
- `-P` sets the default Policy for a chain
- INPUT and OUTPUT accept all packets by default
- FORWARD drops all packets by default (prevents unintended routing)

**Verification:**
```bash
iptables -L -v -n
```

---

### Stage 3: Challenge #2 - Listing Rules

**Objective:** List only the filter table of the INPUT chain.

```bash
sudo iptables -L INPUT -v -n
```

**Explanation:**
- `-L INPUT` lists only INPUT chain rules
- `-v` shows verbose information (packet count, byte count)
- `-n` displays IP and port without DNS translation (faster)

**Expected Output:** INPUT chain visible with zero packet counts

---

### Stage 4: Challenge #3 - The NAT Table

**Objective:** List the NAT table.

```bash
sudo iptables -t nat -L -v -n
```

**Explanation:**
- `-t nat` selects the NAT table (not the filter table)
- NAT table used for Network Address Translation
- Initially empty unless NAT was previously configured

---

### Stage 5: Challenge #4 - Flushing

**Objective:** Flush the filter table of all rules.

```bash
sudo iptables -F
```

**Explanation:**
- `-F` or `--flush` removes all rules from all chains in the filter table
- Default Policy remains unchanged after flush
- Essential for starting with a clean slate

**Verification:**
```bash
sudo iptables -L -v -n
```

---

### Stage 6: Challenge #5 - Dropping Specific Traffic

**Objective:** Drop all incoming packets to port 22/tcp (SSH). This should be the first rule in the chain.

```bash
sudo iptables -I INPUT 1 -p tcp --dport 22 -j DROP
```

**Explanation:**
- `-I INPUT 1` inserts rule at position 1 (first rule)
- `-p tcp` limits to TCP protocol
- `--dport 22` specifies destination port SSH
- `-j DROP` blocks matching packets

**Verification:**
```bash
sudo iptables -L INPUT -v -n --line-numbers
```

---

### Stage 7: Challenge #6 - Reset / Delete Firewall

**Objective:** Flush all tables and set ACCEPT policy on all chains (WARNING: Removes all firewall rules)

```bash
# Flush all chains in all tables
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t mangle -F

# Delete all user-defined chains
sudo iptables -X

# Set ACCEPT policy on all default chains
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
```

**Verification:**
```bash
sudo iptables -L -v -n
sudo iptables -t nat -L -v -n
sudo iptables -t mangle -L -v -n
```

---

## Part 2: Basic Matches

### Stage 8: Challenge #1 - Filter by IP

**Objective:** Drop incoming packets from 100.0.0.1 and 1.2.3.4, drop outgoing packets to 80.0.0.1.

```bash
# Block incoming IPs
sudo iptables -I INPUT 1 -s 100.0.0.1 -j DROP
sudo iptables -I INPUT 1 -s 1.2.3.4 -j DROP

# Block outgoing IP
sudo iptables -I OUTPUT 1 -d 80.0.0.1 -j DROP
```

**Explanation:**
- `-s` specifies source IP (incoming packets)
- `-d` specifies destination IP (outgoing packets)
- `-I` inserts at specified position (rules checked in order)

**Verification:**
```bash
sudo iptables -L INPUT -v -n --line-numbers
sudo iptables -L OUTPUT -v -n --line-numbers
```

---

### Stage 9: Challenge #2 - Drop Specific Outgoing TCP

**Objective:** Drop all outgoing TCP packets (port 80 and 443) to www.linuxquestions.org.

Example IPs: 104.24.137.8, 172.67.81.99, 104.24.136.8

```bash
# For 104.24.137.8
sudo iptables -I OUTPUT 1 -p tcp -d 104.24.137.8 --dport 80 -j DROP
sudo iptables -I OUTPUT 1 -p tcp -d 104.24.137.8 --dport 443 -j DROP

# For 172.67.81.99
sudo iptables -I OUTPUT 1 -p tcp -d 172.67.81.99 --dport 80 -j DROP
sudo iptables -I OUTPUT 1 -p tcp -d 172.67.81.99 --dport 443 -j DROP

# For 104.24.136.8
sudo iptables -I OUTPUT 1 -p tcp -d 104.24.136.8 --dport 80 -j DROP
sudo iptables -I OUTPUT 1 -p tcp -d 104.24.136.8 --dport 443 -j DROP
```

**Explanation:**
- `-p tcp` matches TCP protocol only
- `--dport` specifies destination port
- Blocks both HTTP (80) and HTTPS (443) traffic

---

### Stage 10: Challenge #3 - Drop Routed Traffic

**Objective:** Drop all routed outgoing packets (TCP port 80 and 443) to www.linuxquestions.org.

```bash
# Apply same rules to FORWARD chain instead of OUTPUT
# For 104.24.137.8
sudo iptables -I FORWARD 1 -p tcp -d 104.24.137.8 --dport 80 -j DROP
sudo iptables -I FORWARD 1 -p tcp -d 104.24.137.8 --dport 443 -j DROP

# For 172.67.81.99
sudo iptables -I FORWARD 1 -p tcp -d 172.67.81.99 --dport 80 -j DROP
sudo iptables -I FORWARD 1 -p tcp -d 172.67.81.99 --dport 443 -j DROP

# For 104.24.136.8
sudo iptables -I FORWARD 1 -p tcp -d 104.24.136.8 --dport 80 -j DROP
sudo iptables -I FORWARD 1 -p tcp -d 104.24.136.8 --dport 443 -j DROP
```

**Explanation:**
- FORWARD chain controls traffic passing through the router
- Blocks traffic from LAN clients to the website through router gateway

---

### Stage 11: Challenge #4 - Drop Subnet

**Objective:** Drop all incoming packets from network 27.103.0.0/16 (first rule in chain).

```bash
sudo iptables -I INPUT 1 -s 27.103.0.0/16 -j DROP
```

**Explanation:**
- `-s 27.103.0.0/16` specifies source network range
- CIDR notation: /16 = 255.255.0.0 netmask
- Blocks entire subnet with single rule (efficient)

---

### Stage 12: Challenge #5 - Enforce DNS Server

**Objective:** Drop UDP packets to port 53 (DNS) if destined to any IP other than 8.8.8.8.

```bash
sudo iptables -I FORWARD 1 -p udp --dport 53 ! -d 8.8.8.8 -j DROP
```

**Explanation:**
- `-p udp` matches UDP protocol (DNS uses UDP port 53)
- `! -d 8.8.8.8` means NOT destination 8.8.8.8 (negation operator)
- Forces LAN users to use only authorized DNS server (Google DNS)

---

### Stage 13: Challenge #6 - Allow Loopback

**Objective:** Allow all traffic on the loopback (lo) interface.

```bash
sudo iptables -I INPUT 1 -i lo -j ACCEPT
sudo iptables -I OUTPUT 1 -o lo -j ACCEPT
```

**Explanation:**
- `-i lo` specifies incoming loopback interface
- `-o lo` specifies outgoing loopback interface
- Essential for internal system services (localhost communications)

---

### Stage 14: Challenge #7 - Interface Specific SSH

**Objective:** Allow routed incoming SSH (tcp/22) only from LAN (enp0s8). Drop SSH from WAN (enp0s3).

```bash
# Allow SSH from LAN
sudo iptables -I FORWARD 1 -p tcp -i enp0s8 --dport 22 -j ACCEPT

# Block SSH from WAN
sudo iptables -I FORWARD 2 -p tcp -i enp0s3 --dport 22 -j DROP
```

**Explanation:**
- `-i enp0s8` specifies LAN interface
- `-i enp0s3` specifies WAN interface
- Rule order matters: ACCEPT first, then DROP
- Prevents external SSH access while allowing internal management

---

## Part 3: Advanced Matches

### Stage 15: Challenge #1 - Help Commands

Display advanced match options:

```bash
sudo iptables -m time --help
sudo iptables -m mac --help
sudo iptables -m limit --help
```

These commands show available options for time-based, MAC address, and rate limiting matches.

---

### Stage 16: Challenge #2 - Stateful Firewall (Basic)

**Objective:** Create a basic stateful firewall for a laptop. All outgoing traffic allowed, only return incoming traffic permitted.

```bash
sudo nano stateful_fw.sh
```

**Script content:**
```bash
#!/bin/bash
iptables -F
iptables -X
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

**Execute:**
```bash
sudo chmod +x stateful_fw.sh
sudo ./stateful_fw.sh
```

---

### Stage 17: Challenge #3 - Stateful Firewall (Complete)

**Objective:** Enhanced firewall with loopback, INVALID drop, and automatic flush.

See `stateful_fw_complete.sh` in scripts folder.

---

### Stage 18: Challenge #4 - Trusted Source SSH

**Objective:** Allow incoming SSH connections (tcp/22) only from trusted IP 100.0.0.1.

```bash
sudo iptables -A INPUT -p tcp -s 100.0.0.1 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
```

**Explanation:**
- `-s 100.0.0.1` limits SSH to trusted source only
- `--state NEW,ESTABLISHED` allows new connections and established ones
- Stateful approach improves security

---

### Stage 19: Challenge #5 - MAC Filtering (Router Only)

**Objective:** Allow communication only with router MAC b4:6d:83:77:85:f5.

```bash
sudo iptables -I INPUT 1 -m mac --mac-source b4:6d:83:77:85:f5 -j ACCEPT
sudo iptables -I INPUT 2 -j DROP
```

**Explanation:**
- First rule accepts traffic from specific MAC address
- Second rule drops all other traffic
- MAC filtering provides device-level access control

---

### Stage 20: Challenge #6 - MAC Whitelist Script

**Objective:** Allow only 5 trusted hosts with specific MAC addresses.

See `mac_whitelist.sh` in scripts folder for complete implementation.

---

### Stage 21: Challenge #7 - Time-Based Web Access

**Objective:** Allow outgoing web traffic (TCP 80/443) only between 10:00 and 18:00 UTC.

```bash
sudo iptables -A OUTPUT -p tcp --dport 80 -m time --timestart 10:00 --timestop 18:00 --kerneltz -j ACCEPT
sudo iptables -A OUTPUT -p tcp --dport 443 -m time --timestart 10:00 --timestop 18:00 --kerneltz -j ACCEPT
```

**Explanation:**
- `-m time` enables time-based matching
- `--timestart` and `--timestop` define allowed time window
- `--kerneltz` uses system timezone

---

### Stage 22: Challenge #8 - Weekend Access Only

**Objective:** Allow web traffic only on weekends (Sat, Sun) between 10:00 and 18:00 UTC.

```bash
sudo iptables -A OUTPUT -p tcp --dport 80 -m time --timestart 10:00 --timestop 18:00 --weekdays Sat,Sun --kerneltz -j ACCEPT
sudo iptables -A OUTPUT -p tcp --dport 443 -m time --timestart 10:00 --timestop 18:00 --weekdays Sat,Sun --kerneltz -j ACCEPT
```

---

### Stage 23: Challenge #9 - Limit Ping

**Objective:** Permit only 2 incoming ICMP echo-request (ping) packets per second.

```bash
sudo iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 2/sec --limit-burst 2 -j ACCEPT
```

**Explanation:**
- `-m limit` enables rate limiting
- `--limit 2/sec` allows 2 packets per second maximum
- `--limit-burst 2` sets initial burst allowance
- Prevents ping flooding attacks

---

### Stage 24: Challenge #10 - Limit TCP Connections

**Objective:** Permit only 10 NEW TCP connections from the same IP address.

```bash
sudo iptables -A INPUT -p tcp --syn -m connlimit --connlimit-above 10 -j REJECT
```

**Explanation:**
- `--syn` matches TCP connection initiation packets
- `-m connlimit` enables connection limiting per IP
- `--connlimit-above 10` rejects if more than 10 concurrent connections
- Prevents SYN flood and connection exhaustion attacks

---

## Part 4: NAT & Port Forwarding

### Stage 25: Challenge #1 - Basic NAT Configuration

**Objective:** Configure NAT for LAN network (10.0.2.0/24).

```bash
# Flush NAT table
sudo iptables -t nat -F

# Enable IP Forwarding
sudo sysctl -w net.ipv4.ip_forward=1

# Apply SNAT for entire subnet
sudo iptables -t nat -A POSTROUTING -s 10.0.2.0/24 -o enp0s3 -j SNAT --to-source 80.0.0.1
```

**For dynamic IP (automatic adjustment):**
```bash
sudo iptables -t nat -A POSTROUTING -s 10.0.2.0/24 -o enp0s3 -j MASQUERADE
```

**For permanent IP forwarding, edit /etc/sysctl.conf:**
```
net.ipv4.ip_forward=1
```

Then apply:
```bash
sudo sysctl -p
```

**Explanation:**
- SNAT translates LAN private IPs to public IP
- MASQUERADE automatically adjusts if public IP changes
- Essential for LAN internet access through router

---

### Stage 26: Challenge #2 - Port Forwarding (DNAT)

**Objective:** Forward external traffic on port 80 to internal web server at 192.168.0.20:80.

```bash
# Basic port forwarding (port 80)
sudo iptables -t nat -A PREROUTING -i enp0s3 -p tcp --dport 80 -j DNAT --to-destination 192.168.0.20:80

# Allow forwarding in FORWARD chain
sudo iptables -A FORWARD -p tcp -d 192.168.0.20 --dport 80 -j ACCEPT

# VARIANT: Redirect external port 8080 to internal server port 80
sudo iptables -t nat -A PREROUTING -i enp0s3 -p tcp --dport 8080 -j DNAT --to-destination 192.168.0.20:80
sudo iptables -A FORWARD -p tcp -d 192.168.0.20 --dport 80 -j ACCEPT
```

**Verification:**
```bash
sudo iptables -t nat -L -v -n --line-numbers
sudo iptables -L FORWARD -v -n --line-numbers
```

**Explanation:**
- PREROUTING chain changes destination before routing decision
- External users access internal web server via router's public IP
- Router forwards traffic to internal server transparently

---

## Lab Completion Summary

This comprehensive lab covered four major areas of Linux firewall configuration:

1. **Basic Commands:** Policies, listing, flushing, and rule management
2. **Basic Matches:** IP filtering, port filtering, subnet blocking, interface-specific rules
3. **Advanced Matches:** Stateful firewalls, MAC filtering, time-based access, rate limiting
4. **NAT & Port Forwarding:** SNAT, MASQUERADE, DNAT for network translation

All challenges documented with commands, explanations, and expected outputs.

---

## Repository

All scripts and documentation available at:
- GitHub: [github.com/salem228h/Cybersecurity-Portfolio](https://github.com/salem228h/Cybersecurity-Portfolio)
- Lab Folder: `/labs/Lab1-iptables/`

## Student Information

- **Name:** Mohammad Salem Hassani
- **Course:** Network Defense / Cybersecurity
- **Instructor:** Asen Grozdanov
- **Due Date:** November 29th, 2025, Midnight
- **Lab Date:** November 2025

---

**Status:** ✅ Complete
