# Linux Hardening Lab - Endpoint Security

## 📋 Lab Information

**Course:** Cybersecurity / Network Defense  
**Module:** Endpoint Security - Linux Systems  
**Instructor:** Asen Grozdanov  
**Student:** Mohammad Salem Hassani  
**Due Date:** November 29th, 2025  
**Lab Date:** November 2025

---

## 🎯 Lab Overview

This lab demonstrates hands-on Linux system hardening techniques focusing on kernel management, package maintenance, SSH configuration, and firewall implementation. The exercises apply defense-in-depth principles and endpoint security best practices used in production environments.

### Learning Objectives
- Understand kernel versioning and system architecture
- Manage system repositories and dependencies effectively
- Identify and remove obsolete kernel versions securely
- Configure SSH for enhanced security
- Implement firewall rules using both CLI and GUI tools
- Apply defense-in-depth principles to Linux systems

### Lab Environment
- **OS:** Linux (Ubuntu/Debian-based)
- **Kernel Version:** 6.14.0 series
- **Tools:** UFW, GUFW, SSH, APT package manager
- **Prerequisites:** Basic Linux command-line knowledge, sudo access

---

## 📝 Exercises

### Exercise 1: System Version Verification

**Objective:** Identify the active kernel version and system architecture.

**Command:**
```bash
uname -mrs
```

**Code Breakdown:**
- `uname`: Display system information
- `-m`: Machine hardware name (x86_64, arm64, etc.)
- `-r`: Kernel release version
- `-s`: Kernel name (Linux)

**Expected Output:**
```
Linux 6.14.0-33-generic x86_64
```

**Security Significance:**
Understanding your kernel version is the first step in hardening. Cross-reference this version against security bulletins to identify pending patches.

**Screenshot:**

![Exercise 1 Screenshot](screenshots/exercise1.png)

---

### Exercise 2: Local Repository Maintenance

**Objective:** Update system packages, apply security patches, and clean unnecessary cache.

**Commands:**

#### Step 1: Update Package Lists
```bash
sudo apt update
```

**Explanation:**
- `sudo`: Execute with superuser privileges
- `apt`: Advanced Package Tool
- `update`: Refreshes package lists from repositories

#### Step 2: Upgrade System
```bash
sudo apt upgrade -y
```

**Explanation:**
- `upgrade`: Installs available updates for installed packages
- `-y`: Automatic "yes" to prompts (non-interactive mode)

#### Step 3: Clean Package Cache
```bash
sudo apt-get autoclean
```

**Explanation:**
- `apt-get`: Lower-level package tool
- `autoclean`: Removes cached packages no longer available in repositories
- Frees disk space (typically 100-500 MB)

**Expected Output:**
```
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Del linux-headers-6.14.0-36-generic
Del linux-modules-extra-6.14.0-36-generic
```

**Screenshot:**

![Exercise 2 Screenshot](screenshots/exercise2.png)

---

### Exercise 3: Kernel Image Audit

**Objective:** Audit installed kernel versions and identify the active kernel.

**Command:**
```bash
dpkg --list | egrep -i 'linux-image|linux-headers'
```

**Code Breakdown:**
- `dpkg --list`: Lists all installed packages
- `|`: Pipe operator (passes output to next command)
- `egrep`: Extended grep (regex pattern matching)
- `-i`: Case-insensitive search
- `'linux-image|linux-headers'`: Search for kernel packages

**Output Interpretation:**
```
ii  linux-image-6.14.0-33-generic          (ACTIVE - Current kernel)
ii  linux-image-6.14.0-36-generic          (OLD - Can be removed)
ii  linux-headers-6.14.0-33-generic        (Headers for active kernel)
ii  linux-headers-6.14.0-36-generic        (Old headers - safe to remove)
```

**Identify Active Kernel:**
```bash
uname -r
```
Output: `6.14.0-33-generic`

Any kernel version different from `uname -r` output can be removed.

**Screenshot:**

![Exercise 3 Screenshot](screenshots/exercise3.png)

---

### Exercise 4: Removal of Unused Dependencies

**Objective:** Remove orphaned packages and unused libraries to free disk space and reduce attack surface.

**Command:**
```bash
sudo apt-get autoremove --purge
```

**Code Breakdown:**
- `autoremove`: Removes packages installed as dependencies that are no longer needed
- `--purge`: Complete removal including configuration files

**Expected Output:**
```
The following packages will be REMOVED:
  linux-headers-6.14.0-36-generic
  linux-modules-6.14.0-36-generic
  linux-image-6.14.0-36-generic
After this operation, 300 MB disk space will be freed.

Do you want to continue? [Y/n] Y
```

**Security Impact:** Old kernel headers may contain exploitable code. Removal reduces attack surface.

**Screenshot:**

![Exercise 4 Screenshot](screenshots/exercise4.png)

---

### Exercise 5: Manual Kernel Hardening

**Objective:** Manually remove obsolete kernels to eliminate security risks.

#### Step 1: Remove Old Kernel
```bash
sudo apt-get purge linux-image-6.14.0-36-generic
```

**Explanation:**
- `purge`: Removes package and all associated files
- Target specific old kernel version

#### Step 2: Verify Kernel List
```bash
dpkg --list | grep linux-image
```

**Expected Output:**
```
ii  linux-image-6.14.0-33-generic          100.5 MB     amd64    Linux kernel image
```

Only the active kernel remains. ✅

**Why Version-Specific Removal Matters:**
- Prevents accidental removal of the active kernel
- Allows selective cleanup of known-vulnerable kernels
- Maintains boot menu clarity

**Screenshot:**

![Exercise 5 Screenshot](screenshots/exercise5.png)

---

### Exercise 6: SSH & Service Hardening

**Objective:** Secure SSH service and disable unnecessary services.

#### Step 1: Check Active Services
```bash
systemctl list-unit-files --type=service | grep enabled
```

**Code Breakdown:**
- `systemctl`: System service manager
- `list-unit-files`: Lists all service configurations
- `--type=service`: Filters to service units only
- `grep enabled`: Shows auto-starting services

#### Step 2: Edit SSH Configuration
```bash
sudo nano /etc/ssh/sshd_config
```

**Critical Security Settings:**
```bash
# Disable remote root login
PermitRootLogin no

# Enable password authentication (for this lab)
PasswordAuthentication yes

# Optional hardening additions:
Port 2222                    # Non-standard port
X11Forwarding no             # Disable GUI tunneling
PermitEmptyPasswords no      # Require passwords
MaxAuthTries 3               # Limit brute force attempts
```

#### Step 3: Restart SSH Service
```bash
sudo systemctl restart ssh
```

**Verification:**
```bash
sudo systemctl status ssh
```

Should show: `Active: running (green)`

**Screenshot:**

![Exercise 6 Screenshot](screenshots/exercise6.png)

---

### Exercise 7: UFW Firewall (CLI)

**Objective:** Implement perimeter defense using Uncomplicated Firewall with default-deny policy.

#### Step 1: Install UFW
```bash
sudo apt install ufw
```

#### Step 2: Set Default Policies
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

**Explanation:**
- `default deny incoming`: Drop all inbound traffic by default (least privilege principle)
- `default allow outgoing`: Permit all outbound traffic

#### Step 3: Allow SSH (Critical!)
```bash
sudo ufw allow 22/tcp
```

**⚠️ WARNING:** Set this BEFORE enabling UFW to avoid lockout!

#### Step 4: Enable Firewall
```bash
sudo ufw enable
```

#### Step 5: Check Status
```bash
sudo ufw status verbose
```

**Expected Output:**
```
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
22/tcp (v6)                ALLOW       Anywhere (v6)

Default: deny (incoming), allow (outgoing)
```

**Screenshot:**

![Exercise 7 Screenshot](screenshots/exercise7.png)

---

### Exercise 8: GUFW Firewall (GUI)

**Objective:** Manage firewall with graphical interface.

#### Step 1: Install GUFW
```bash
sudo apt install gufw
```

#### Step 2: Launch GUFW
```bash
gufw
```

#### Step 3: View Previous Rules
Observe the SSH rule (port 22/TCP) inherited from Exercise 7.

#### Step 4: Add New Rule
**To Allow HTTP Traffic:**
1. Click **Add** button
2. Set Protocol: **TCP**
3. Set Port: **80** (HTTP)
4. Set Direction: **In** (Incoming)
5. Set Action: **Allow**
6. Click **Add Rule**

**Behind the Scenes:**
```bash
sudo ufw allow 80/tcp
```

**Screenshot:**

![Exercise 8 Screenshot](screenshots/exercise8.png)

---

## 📊 Lab Summary

### Accomplishments

| Area | Achievement |
|------|-------------|
| **System Inventory** | Verified kernel version and system architecture |
| **Maintenance** | Updated packages, freed ~300 MB disk space |
| **Kernel Hardening** | Removed obsolete kernels with vulnerabilities |
| **SSH Security** | Disabled root login, configured secure settings |
| **Firewall** | Implemented default-deny policy with UFW/GUFW |

### Key Hardening Principles Applied

| Principle | Implementation | Exercise |
|-----------|----------------|----------|
| **Least Privilege** | Default-deny firewall | Exercise 7 |
| **Defense in Depth** | Multiple security layers | All Exercises |
| **Patch Management** | System updates | Exercise 2 |
| **Attack Surface Reduction** | Remove unused software | Exercises 3-5 |
| **Configuration Auditing** | Service and rule verification | Exercises 1, 3, 6 |

### Security Impact

#### Before Hardening:
- ❌ Multiple old kernel versions with potential vulnerabilities
- ❌ Root login possible via SSH (high-value target)
- ❌ No firewall protection (all ports exposed)
- ❌ Unnecessary packages consuming disk space

#### After Hardening:
- ✅ Single, patched kernel version
- ✅ Root login disabled
- ✅ Firewall restricts traffic to allowed services only
- ✅ Minimal attack surface

---

## 🎓 Learning Outcomes

After completing this lab, I can:

- ✅ Explain the purpose of each hardening step
- ✅ Identify security risks in unpatched systems
- ✅ Apply firewall rules for specific services
- ✅ Manage system packages and kernel versions
- ✅ Secure SSH for remote administration
- ✅ Audit system services for unnecessary exposure
- ✅ Document security configurations
- ✅ Understand defense-in-depth architecture

---

## 🔐 Production Recommendations

### 1. SSH Key Management
```bash
# Generate SSH keypair
ssh-keygen -t ed25519

# Disable password authentication
PasswordAuthentication no
```

### 2. Advanced Firewall Rules
```bash
# Rate limiting (prevent brute force)
sudo ufw limit 22/tcp

# Restrict SSH to specific IP range
sudo ufw allow from 192.168.1.0/24 to any port 22

# Enable logging
sudo ufw logging on
```

### 3. Monitoring & Logging
```bash
# Monitor SSH authentication attempts
sudo tail -f /var/log/auth.log

# Enable system auditing
sudo apt install auditd
sudo systemctl enable auditd
```

### 4. Regular Maintenance Schedule
- **Weekly:** Review system logs
- **Monthly:** `apt update && apt upgrade`
- **Quarterly:** Kernel audits and cleanup
- **Annually:** Full security review

---

## 📁 Repository Structure

```
Cybersecurity-Portfolio/
├── labs/
│   └── linux-hardening/
│       ├── README.md                    (this file)
│       ├── screenshots/
│       │   ├── exercise1.png
│       │   ├── exercise2.png
│       │   ├── exercise3.png
│       │   ├── exercise4.png
│       │   ├── exercise5.png
│       │   ├── exercise6.png
│       │   ├── exercise7.png
│       │   └── exercise8.png
│       └── lab-report.pdf
└── ...
```

---

## ✅ Lab Completion Checklist

- [ ] Exercise 1: System version verified ✓
- [ ] Exercise 2: System updated and cleaned ✓
- [ ] Exercise 3: Kernel audit completed ✓
- [ ] Exercise 4: Dependencies removed ✓
- [ ] Exercise 5: Old kernel manually removed ✓
- [ ] Exercise 6: SSH hardened ✓
- [ ] Exercise 7: UFW firewall configured ✓
- [ ] Exercise 8: GUFW interface demonstrated ✓
- [ ] All 8 screenshots captured and uploaded ✓
- [ ] Lab report documented ✓
- [ ] Repository updated on GitHub ✓

---

## 🔗 References

- [Ubuntu Security Guide](https://ubuntu.com/security)
- [UFW Documentation](https://help.ubuntu.com/community/UFW)
- [OpenSSH Security](https://www.openssh.com/security.html)
- [Linux Kernel Security](https://www.kernel.org/doc/html/latest/admin-guide/security.html)

---

**Prepared by:** Mohammad Salem Hassani  
**GitHub:** [@salem228h](https://github.com/salem228h)  
**Repository:** [Cybersecurity-Portfolio](https://github.com/salem228h/Cybersecurity-Portfolio)  
**Date:** November 2025
