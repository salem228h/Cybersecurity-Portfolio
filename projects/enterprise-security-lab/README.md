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
