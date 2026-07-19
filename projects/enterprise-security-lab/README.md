# 🏢 Enterprise Cybersecurity Lab

> Virtualized corporate network environment for hands-on security practice.  
> Firewall · VLAN · Active Directory · SIEM · Linux Hardening

![](https://img.shields.io/badge/Status-Active-brightgreen)
![](https://img.shields.io/badge/Tools-Open--Source%20Only-blue)
![](https://img.shields.io/badge/Platform-VirtualBox-lightgrey)

---

## Overview

A hands-on enterprise security lab simulating a real-world corporate network.
Covers network segmentation, system hardening, access control,
and SOC monitoring — built entirely with open-source tools.

---

## Environment

| VM | OS | Role | IP |
|----|----|------|----|
| OPNsense | FreeBSD | Firewall / Router | 10.10.20.1 |
| DC01 | Windows Server 2022 | Domain Controller | 10.10.20.10 |
| FS01 | Ubuntu 24.04 | File Server | 10.10.20.20 |
| WKS01 | Windows 11 | User Workstation | 10.10.20.30 |
| Web01 | Ubuntu 24.04 | Web Server (DMZ) | 10.10.30.10 |
| Wazuh | CentOS | SIEM | 10.10.20.54 |
| Kali | Kali Linux | Admin / Security | 10.10.20.50 |

---

## Network Design
Internet
│
OPNsense (Firewall / Router)
├── VLAN 20 — CORP     10.10.20.0/24  (DC01 · FS01 · WKS01 · Wazuh · Kali)
├── VLAN 30 — DMZ      10.10.30.0/24  (Web01)
├── VLAN 40 — SOC      10.10.40.0/24  (monitoring)
└── VLAN 10 — MGMT     10.10.10.0/24  (admin access only)

Default-deny between all VLANs.
Traffic permitted only via explicit firewall rules.

---

## Security Controls

**Firewall — OPNsense**
- Default-deny policy on all interfaces
- VLAN segmentation — 4 isolated segments
- Suricata IDS with custom detection rules
- Admin access restricted to MGMT VLAN only

**Active Directory — Windows Server 2022**
- SMBv1 disabled (no EternalBlue / WannaCry vector)
- NTLMv1 disabled — NTLMv2 only via GPO
- LAPS deployed — unique local admin password per machine
- Kerberos pre-authentication enforced (AS-REP Roasting blocked)
- Account lockout: 5 attempts · 30-minute lockout

**Linux Hardening — Ubuntu 24.04**
- SSH: key-only authentication · root login disabled · port changed
- Fail2Ban: 5 failures → 24-hour ban
- UFW firewall: allow-list only
- auditd: full command and file-access logging
- Lynis hardening score: 76 / 100

**SIEM — Wazuh**
- Agents deployed on all Linux and Windows hosts
- Custom detection rules for brute force · Samba anomaly · web attacks
- Real-time alerting on authentication failures and privilege escalation

---

## Skills Practiced

- Enterprise network design and VLAN segmentation
- Firewall rule management (OPNsense)
- Active Directory administration and GPO hardening
- Linux server hardening (SSH · UFW · Fail2Ban · auditd)
- SIEM deployment and custom rule writing (Wazuh · Suricata)
- Vulnerability assessment and remediation
- Security monitoring and log analysis

---

## Technologies

`OPNsense` `Suricata` `Wazuh` `Windows Server 2022` `Active Directory`  
`Ubuntu 24.04` `Kali Linux` `VirtualBox` `LAPS` `Fail2Ban` `UFW` `auditd`

---

## Related Project

> This lab is the foundation for the  
> **[🏆 NordForge Capstone](https://github.com/salem228h/nordforge-capstone)**  
> — a full 4-stage enterprise cybersecurity program built on top of this environment.

---

## Author

**Mohammad Salem Hassani**  
