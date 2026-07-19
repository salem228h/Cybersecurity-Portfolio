markdown# 🛡️ Wazuh SIEM & XDR Implementation

> Production-ready Wazuh deployment for endpoint monitoring,
> threat detection, and security event analysis.

![](https://img.shields.io/badge/Wazuh-4.x-blue)
![](https://img.shields.io/badge/Status-Active-brightgreen)
![](https://img.shields.io/badge/Platform-Open--Source-lightgrey)

---

## Overview

End-to-end deployment and configuration of Wazuh SIEM/XDR
in a multi-host enterprise lab environment.
Covers agent deployment, log collection, custom rule writing,
and alert investigation across Linux and Windows endpoints.

---

## Architecture
┌─────────────────────────────────────────┐
│           Wazuh Server (CentOS)         │
│   Manager · Indexer · Dashboard         │
│           10.10.20.54                   │
└──────────────┬──────────────────────────┘
│ Agent communication (1514/TCP)
┌───────┴────────┐
│                │
Linux Agents    Windows Agents
FS01 · Web01    DC01 · WKS01

---

## What Was Deployed

**Wazuh Manager**
- Wazuh Manager · Indexer · Dashboard — single-node deployment
- TLS-encrypted agent communication
- Real-time alert pipeline with custom rule engine

**Agents**
| Host | OS | Agent Status |
|------|----|-------------|
| DC01 | Windows Server 2022 | ✅ Active |
| WKS01 | Windows 11 | ✅ Active |
| FS01 | Ubuntu 24.04 | ✅ Active |
| Web01 | Ubuntu 24.04 | ✅ Active |

---

## Custom Detection Rules

```xml
<!-- Rule 100001: SSH Brute Force -->
<rule id="100001" level="12" frequency="5" timeframe="60">
  <if_matched_sid>5716</if_matched_sid>
  <description>SSH brute force — 5 failures in 60s (T1110)</description>
</rule>

<!-- Rule 100002: Samba Authentication Anomaly -->
<rule id="100002" level="10">
  <if_sid>5720</if_sid>
  <match>smbd|samba|NTLMSSP</match>
  <description>Samba auth anomaly — possible CVE-2007-2447 (T1210)</description>
</rule>

<!-- Rule 100003: Root Session Opened -->
<rule id="100003" level="13">
  <if_sid>5501</if_sid>
  <match>session opened for user root</match>
  <description>Root session opened — verify authorized (T1078)</description>
</rule>

<!-- Rule 100004: Web Attack Pattern -->
<rule id="100004" level="11">
  <if_sid>31100,31101</if_sid>
  <url_match>union|select|script|alert|onerror</url_match>
  <description>Web attack — SQLi or XSS pattern (T1190)</description>
</rule>
```

---

## Alerts Captured

| Event | Rule ID | Level | MITRE |
|-------|---------|-------|-------|
| SSH brute force on FS01 | 100001 | 12 — Critical | T1110 |
| Samba exploit attempt | 100002 | 10 — High | T1210 |
| Root session via exploit | 100003 | 13 — Critical | T1078 |
| SQL Injection on DVWA | 100004 | 11 — High | T1190 |
| AS-REP Roasting attempt | 60106 | 12 — Critical | T1558.004 |
| Windows login failures | 60204 | 10 — High | T1110.003 |

---

## Log Sources Collected

- Linux: `/var/log/auth.log` · `/var/log/syslog` · auditd
- Windows: Security Event Log · System Log · Application Log
- Apache: access log · error log (Web01)
- Samba: authentication and connection logs (FS01)
- Custom: OPNsense firewall syslog forwarded to Wazuh

---

## Key Outcomes

- ✅ Detected SSH brute-force attack in under **6 minutes**
- ✅ Correlated Samba exploit with root session — single alert chain
- ✅ Identified authentication anomalies across 4 hosts simultaneously
- ✅ Zero false positives after rule tuning
- ⚠️ Gap identified: intra-VLAN traffic not captured without span port

---

## Repository Contents
wazuh-siem/
├── config/
│   ├── ossec.conf              # Wazuh manager config
│   └── agent.conf              # Centralized agent policy
├── rules/
│   └── nordforge_custom.xml    # Custom detection rules
├── screenshots/
│   ├── dashboard_overview.png
│   ├── alert_brute_force.png
│   └── custom_rules_active.png
├── docs/
│   └── deployment_guide.md
└── README.md

---

## Skills Demonstrated

`SIEM Deployment` `Agent Configuration` `Custom Rule Writing`  
`Log Analysis` `Threat Detection` `Alert Investigation`  
`MITRE ATT&CK Mapping` `Incident Triage` `Security Monitoring`

---

## Related Projects

> Built as part of the  
> **[🏆 NordForge Capstone](https://github.com/salem228h/nordforge-capstone)**  
> and the  
> **[🏢 Enterprise Security Lab](https://github.com/salem228h/enterprise-security-lab)**

---

## Author

**Mohammad Salem Hassani**  

