# Lab #1: Configuring iptables Rules Manually

## Course Information
- **Course:** Network Defense / Cybersecurity
- **Instructor:** Asen Grozdanov
- **Student:** Mohammad Salem Hassani
- **Lab Date:** November 2025
- **Due Date:** November 29th, 2025, Midnight (23:59)

## Lab Overview

This lab provides comprehensive hands-on experience with **Linux packet filtering firewalls** using the `iptables` command-line interface. Students configure firewall rules across four major components: basic iptables commands, basic packet matching, advanced packet matching, and Network Address Translation (NAT) with port forwarding.

## Learning Objectives

By completing this lab, students will:
- Master fundamental `iptables` commands and firewall policies
- Implement stateful firewall rules for network defense
- Configure advanced packet filtering using MAC addresses and time-based access
- Set up Network Address Translation (NAT) for LAN internet access
- Deploy port forwarding (DNAT) for internal web server access
- Create reusable firewall scripts for automated configuration

## Lab Environment

### Network Configuration
- **Subnet:** 10.0.2.0/24
- **Router VM:** Xubuntu Router
  - WAN Interface (Internet): enp0s3
  - LAN Interface (Gateway): enp0s8
  - IP Address: 10.0.2.1
- **Client VM:** Client Machine
  - Interface: eth0
  - Gateway: 10.0.2.1
  - IP Address: 10.0.2.100

## Lab Structure

This lab is divided into **4 main parts** with multiple challenges in each:

### Part 1: The iptables Command
- Setup and initial configuration
- Default firewall policies
- Rule listing and verification
- NAT table exploration
- Rule flushing and deletion

### Part 2: Basic Matches
- IP-based filtering (source and destination)
- Port-specific filtering
- Subnet blocking
- DNS server enforcement
- Loopback interface rules
- Interface-specific firewall rules

### Part 3: Advanced Matches
- Stateful firewall configuration
- MAC address filtering
- MAC whitelist scripts
- Time-based access control
- Weekend-only access restrictions
- ICMP rate limiting (ping)
- TCP connection limiting

### Part 4: NAT & Port Forwarding
- Basic NAT configuration for LAN
- SNAT (Source NAT) for outbound traffic
- MASQUERADE for dynamic IPs
- DNAT (Destination NAT) for port forwarding
- Redirecting external traffic to internal servers

## Key Commands Reference

### Policy Management
```bash
sudo iptables -P INPUT ACCEPT      # Set INPUT policy to ACCEPT
sudo iptables -P OUTPUT ACCEPT     # Set OUTPUT policy to ACCEPT
sudo iptables -P FORWARD DROP      # Set FORWARD policy to DROP
```

### Rule Listing
```bash
sudo iptables -L -v -n             # List all rules with details
sudo iptables -L INPUT -v -n       # List INPUT chain only
sudo iptables -t nat -L -v -n      # List NAT table
```

### Basic Rules
```bash
sudo iptables -A INPUT -p tcp --dport 22 -j DROP     # Drop SSH
sudo iptables -I INPUT 1 -s 100.0.0.1 -j DROP        # Block source IP
sudo iptables -A INPUT -p udp --dport 53 ! -d 8.8.8.8 -j DROP  # DNS enforcement
```

### NAT Configuration
```bash
sudo sysctl -w net.ipv4.ip_forward=1                  # Enable IP forwarding
sudo iptables -t nat -A POSTROUTING -s 10.0.2.0/24 -o enp0s3 -j MASQUERADE
sudo iptables -t nat -A PREROUTING -i enp0s3 -p tcp --dport 80 -j DNAT --to-destination 192.168.0.20:80
```

## Scripts Included

### 1. stateful_fw.sh
Basic stateful firewall for laptop with outgoing traffic allowed and only return incoming traffic permitted.

### 2. stateful_fw_complete.sh
Enhanced stateful firewall with loopback support and INVALID packet dropping.

### 3. mac_whitelist.sh
MAC address-based access control allowing only 5 trusted devices.

## Screenshots and Verification

Each challenge includes:
- Command execution screenshots
- Output verification screenshots
- Expected results documentation

Screenshots are organized by part and challenge in the `screenshots/` folder for easy reference and documentation.

## Submission Details

- **Platform:** Omnivox Lea (DropBox)
- **Repository:** [github.com/salem228h/Cybersecurity-Portfolio](https://github.com/salem228h/Cybersecurity-Portfolio)
- **Username:** salem228h

## Related Skills

This lab reinforces knowledge in:
- Network security fundamentals
- Firewall configuration and management
- Network Access Control (NAC)
- Stateful packet inspection
- Network Address Translation
- Linux system administration
- Bash scripting

## Resources

- [iptables man page](https://linux.die.net/man/8/iptables)
- [Netfilter Project](https://www.netfilter.org/)
- Linux Foundation Documentation
- Network Defense Course Materials

---

**Status:** ✅ Complete  
**Last Updated:** November 2025

