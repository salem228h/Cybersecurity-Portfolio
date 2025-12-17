# Lab 04: Network Reconnaissance & Firewall Evasion

## Course
Cyber Defense

## Prepared By
**Mohammad Salem Hassani**  
Institution: Asen Grozdanov  
Date: 2025-12-15

---
## 📄 Full Lab Report (PDF)

[Open Full Lab Report](Network_Reconnaissance_&_Firewall_Evasion.pdf)


## Lab Overview
This lab covers the **Reconnaissance** and **Firewall Evasion** phases of the Cyber Kill Chain from both offensive and defensive perspectives.

Students first acted as an external attacker performing network scanning and evasion techniques. Then, they switched to a Blue Team role to detect and analyze the attacks using firewall logs and a Snort Intrusion Detection System (IDS).

---

## Lab Objectives
- Configure a firewall with a semi-restricted DMZ environment
- Perform network reconnaissance using port scanning and banner grabbing
- Bypass firewall restrictions using SSH tunneling (port forwarding)
- Detect reconnaissance and evasion activity using firewall logs
- Create and test custom Snort IDS rules

---

## Infrastructure Overview

| Component | Description | IP Address |
|---------|-------------|------------|
| Attacker (WAN) | Kali Linux | External |
| Firewall | OPNsense | WAN / LAN / DMZ |
| DMZ Server | Metasploitable / Web Server | 192.168.2.10 |
| LAN Server | Windows Server 2019 (IAM / AD) | 192.168.1.10 |

Direct WAN-to-LAN traffic is blocked by firewall policy. Limited WAN-to-DMZ access is allowed.

---

## Reconnaissance Phase
- TCP SYN scanning using Nmap
- Service version detection
- Banner grabbing via Netcat and Nmap NSE

Reconnaissance revealed SSH (port 22) as a viable entry point on the DMZ server.

---

## Firewall Evasion Phase
SSH local port forwarding was used to bypass firewall rules and access an internal LAN service.

```bash
ssh -L 3333:192.168.1.10:3389 vagrant@192.168.2.10

