
# 🏆 NordForge Industries — Enterprise Cybersecurity Capstone

> End-to-end cybersecurity program for a 180-employee manufacturer.  
> 4 stages · 8 VMs · 4 VLANs · Open-source tools only.

![](https://img.shields.io/badge/Stages-4%2F4%20Complete-brightgreen)
![](https://img.shields.io/badge/Tools-Open--Source%20Only-blue)
![](https://img.shields.io/badge/Framework-NIST%20%7C%20MITRE%20ATT%26CK-orange)

---

## Overview

Full-cycle cybersecurity engagement covering risk assessment,
system hardening, penetration testing, and incident response —
built in a virtualized lab using industry-standard frameworks.

---

## Stages

**Stage 1 — Risk Assessment**
- 8-VM VirtualBox lab · 4 VLANs (CORP · DMZ · SOC · MGMT)
- 15-item risk register using NIST SP 800-30
- Full asset inventory with CIA triad classification

**Stage 2 — Hardening**
- OPNsense default-deny firewall · Web01 isolated in real DMZ
- Linux: Lynis score 56 → 76 · SSH key-only · Fail2Ban · UFW
- Active Directory: SMBv1 off · NTLMv1 off · LAPS · Kerberos pre-auth enforced

**Stage 3 — Penetration Testing**
- Samba CVE-2007-2447 → root shell in < 3 minutes
- SQL Injection on DVWA → 5 accounts extracted
- AS-REP Roasting → password cracked with hashcat
- All Stage 2 controls validated · Suricata blind spot identified

**Stage 4 — Incident Response**
- Live IR simulation (NIST 800-61) · contained & recovered
- 4 custom Wazuh rules · 3 custom Suricata rules deployed
- IRP v1.0 + 3 playbooks: Phishing · Ransomware · Web Attack
- User awareness program + GoPhish KPI plan

---

## Key Findings

| Finding | CVSS | Outcome |
|---------|------|---------|
| Samba CVE-2007-2447 RCE | 10.0 | Exploited → root shell |
| AS-REP Roasting | 8.1 | Password cracked |
| AS-REP (post-hardening) | — | ✅ Blocked |
| SQL Injection (DVWA) | 9.8 | 5 accounts extracted |
| SMBv1 CVE-2017-0144 | 9.3 | ✅ Remediated |

---

## Tools

| Category | Tools |
|----------|-------|
| Firewall / IDS | OPNsense · Suricata |
| SIEM | Wazuh |
| Pentest | Metasploit · Nmap · Burp Suite · impacket · hashcat |
| Hardening | Lynis · Fail2Ban · UFW · auditd |
| Awareness | GoPhish |

---

## Authors
Mohammad Salem Hassani · Ali Assaad  
Course 420-4C2-DW · Cyber.SoHo · June 2026

- Final Project Report
- Network Diagrams
- Security Screenshots
