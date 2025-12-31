#!/bin/sh
# Simple redirection: Log everything to a file, no pipes/tee
exec > /var/log/user-data.log 2>&1

echo "--- Starting Script ---"

# 1. Update and Install
dnf update -y
dnf install -y nginx

# 2. Get Metadata (IMDSv2) - Using basic curl
# We get the token first (Required by AL2023)
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Use the token to get details
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)

# 3. Write the HTML file
# Using a simple heredoc
cat <<EOF > /usr/share/nginx/html/index.html
<html>
<body style="font-family: Arial; text-align: center;">
  <h1 style="color: #232f3e;">Infrastructure Live</h1>
  <p><b>Instance ID:</b> $INSTANCE_ID</p>
  <p><b>Availability Zone:</b> $AZ</p>
  <hr>
  <p>Managed by Terraform</p>
</body>
</html>
EOF

# 4. Start Nginx
systemctl enable nginx
systemctl start nginx

echo "--- Script Finished ---"