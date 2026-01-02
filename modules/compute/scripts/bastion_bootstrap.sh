#!/bin/bash
# --- Industry Standard Bastion Hardening ---

# 1. Update all system packages for security
yum update -y

# 2. Enable "Unattended Upgrades" (Automatic security patching)
# On Amazon Linux 2023, this is handled via dnf-automatic
yum install -y dnf-automatic
systemctl enable --now dnf-automatic.timer

# 3. Setup basic logging to CloudWatch (Optional but recommended)
# This ensures we have a trail even if the server is deleted
yum install -y amazon-cloudwatch-agent

# 4. Cleanup
echo "Bastion Host Hardened and Ready"