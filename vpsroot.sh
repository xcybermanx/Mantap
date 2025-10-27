#!/bin/bash
# Modified by SL

# Download sshd_config from the given URL and overwrite local /etc/ssh/sshd_config
wget -qO /etc/ssh/sshd_config https://raw.githubusercontent.com/fisabiliyusri/Mantap/main/sshd_config

# Restart sshd to apply new config
systemctl restart sshd

clear

# Prompt for password
echo -n "Enter password: "
read -s pwe
echo

# Set root password (using perl crypt like original)
usermod -p "$(perl -e 'print crypt($ARGV[0],"Q4")' "$pwe")" root

clear

# Print account info
cat <<EOF
Please save this VPS account information
============================================
Root Account (Main Account)
IP address = $(curl -Ls http://ipinfo.io/ip)
Username   = root
Password   = $pwe
============================================
EOF

exit 0
