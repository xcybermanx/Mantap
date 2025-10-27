#!/bin/bash
# Check if run as root
if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this script as root"
    exit 1
fi

# Check virtualization type
if [ "$(systemd-detect-virt)" == "openvz" ]; then
    echo "OpenVZ is not supported"
    exit 1
fi

# ==========================================
# Color definitions
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ==========================================

# URLs for configuration scripts
sshvpn="raw.githubusercontent.com/xcybermanx/Mantap/main/ssh"
sstp="raw.githubusercontent.com/xcybermanx/Mantap/main/sstp"
ssr="raw.githubusercontent.com/xcybermanx/Mantap/main/ssr"
shadowsocks="raw.githubusercontent.com/xcybermanx/Mantap/main/shadowsocks"
wireguard="raw.githubusercontent.com/xcybermanx/Mantap/main/wireguard"
xray="raw.githubusercontent.com/xcybermanx/Mantap/main/xray"
ipsec="raw.githubusercontent.com/xcybermanx/Mantap/main/ipsec"
backup="raw.githubusercontent.com/xcybermanx/Mantap/main/backup"
websocket="raw.githubusercontent.com/xcybermanx/Mantap/main/websocket"
ohp="raw.githubusercontent.com/xcybermanx/Mantap/main/ohp"

# Get public IP
MYIP=$(wget -qO- ipinfo.io/ip)
echo "Checking VPS..."
IZIN=$(wget -qO- ipinfo.io/ip)

rm -f setup.sh
clear

# If already installed, exit
if [ -f "/etc/xray/domain" ]; then
    echo "Script already installed."
    exit 0
fi

# Create configuration folder
mkdir /var/lib/crot
echo "IP=" >> /var/lib/crot/ipvps.conf

# Install host configuration
wget https://${sshvpn}/slhost.sh && chmod +x slhost.sh && ./slhost.sh

# Install Xray
wget https://${xray}/ins-xray.sh && chmod +x ins-xray.sh && screen -S xray ./ins-xray.sh

# Install SSH & OpenVPN
wget https://${sshvpn}/ssh-vpn.sh && chmod +x ssh-vpn.sh && screen -S ssh-vpn ./ssh-vpn.sh

# Install SSTP
wget https://${sstp}/sstp.sh && chmod +x sstp.sh && screen -S sstp ./sstp.sh

# Install SSR
wget https://${ssr}/ssr.sh && chmod +x ssr.sh && screen -S ssr ./ssr.sh

# Install Shadowsocks
wget https://${shadowsocks}/sodosok.sh && chmod +x sodosok.sh && screen -S ss ./sodosok.sh

# Install WireGuard
wget https://${wireguard}/wg.sh && chmod +x wg.sh && screen -S wg ./wg.sh

# Install L2TP/IPSec
wget https://${ipsec}/ipsec.sh && chmod +x ipsec.sh && screen -S ipsec ./ipsec.sh

# Install backup configuration
wget https://${backup}/set-br.sh && chmod +x set-br.sh && ./set-br.sh

# Install WebSocket
wget https://${websocket}/edu.sh && chmod +x edu.sh && ./edu.sh

# Install OHP server
wget https://${ohp}/ohp.sh && chmod +x ohp.sh && ./ohp.sh

# Install SlowDNS
wget https://raw.githubusercontent.com/xcybermanx/Mantap/main/SLDNS/install-sldns && chmod +x install-sldns && ./install-sldns

# (Other optional installs are commented out)

# Cleanup
rm -f /root/ssh-vpn.sh
rm -f /root/sstp.sh
rm -f /root/wg.sh
rm -f /root/ss.sh
rm -f /root/ssr.sh
rm -f /root/ins-xray.sh
rm -f /root/ipsec.sh
rm -f /root/set-br.sh
rm -f /root/edu.sh
rm -f /root/ohp.sh
rm -f /root/install
rm -f /root/sl-grpc.sh
rm -f /root/install-sldns
rm -f /root/install-ss-plugin.sh

# Create systemd service for auto settings
cat <<EOF> /etc/systemd/system/autosett.service
[Unit]
Description=autosetting
Documentation=nekopoi.care

[Service]
Type=oneshot
ExecStart=/bin/bash /etc/set.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable autosett

# Download and set /etc/set.sh
wget -O /etc/set.sh "https://${sshvpn}/set.sh"
chmod +x /etc/set.sh

# Clear command history
history -c

echo "1.2" > /home/ver
echo ""
echo "Installation has been completed!"
echo ""
echo "============================================================================" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "----------------------------------------------------------------------------" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "   >>> Services & Ports" | tee -a log-install.txt
echo "   - SlowDNS SSH             : All SSH Ports" | tee -a log-install.txt
echo "   - OpenSSH                 : 22, 2253" | tee -a log-install.txt
echo "   - OpenVPN                 : TCP 1194, UDP 2200, SSL 990" | tee -a log-install.txt
echo "   - Stunnel5                : 443, 445" | tee -a log-install.txt
echo "   - Dropbear                : 443, 109, 143" | tee -a log-install.txt
echo "   - CloudFront WebSocket    : " | tee -a log-install.txt
echo "   - SSH WebSocket TLS       : 443" | tee -a log-install.txt
echo "   - SSH WebSocket HTTP      : 8880" | tee -a log-install.txt
echo "   - WebSocket OpenVPN       : 2086" | tee -a log-install.txt
echo "   - Squid Proxy             : 3128, 8080" | tee -a log-install.txt
echo "   - Badvpn                  : 7100, 7200, 7300" | tee -a log-install.txt
echo "   - Nginx                   : 89" | tee -a log-install.txt
echo "   - WireGuard               : 7070" | tee -a log-install.txt
echo "   - L2TP/IPSEC VPN          : 1701" | tee -a log-install.txt
echo "   - PPTP VPN                : 1732" | tee -a log-install.txt
echo "   - SSTP VPN                : 444" | tee -a log-install.txt
echo "   - Shadowsocks-R           : 1443–1543" | tee -a log-install.txt
echo "   - SS-OBFS TLS             : 2443–2543" | tee -a log-install.txt
echo "   - SS-OBFS HTTP            : 3443–3543" | tee -a log-install.txt
echo "   - XRAY Vmess TLS          : 8443" | tee -a log-install.txt
echo "   - XRAY Vmess Non-TLS      : 80" | tee -a log-install.txt
echo "   - XRAY Vless TLS          : 8443" | tee -a log-install.txt
echo "   - XRAY Vless Non-TLS      : 80" | tee -a log-install.txt
echo "   - XRAY Trojan             : 2083" | tee -a log-install.txt
echo "   - XRAY VMESS gRPC         : 1180" | tee -a log-install.txt
echo "   - XRAY VLESS gRPC         : 2280" | tee -a log-install.txt
echo "   - OHP SSH                 : 8181" | tee -a log-install.txt
echo "   - OHP Dropbear            : 8282" | tee -a log-install.txt
echo "   - OHP OpenVPN             : 8383" | tee -a log-install.txt
echo "   - TrojanGo                : 2087" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "   >>> Server Information & Features" | tee -a log-install.txt
echo "   - Timezone                : Asia/Jakarta (GMT +7)" | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]" | tee -a log-install.txt
echo "   - Dflate                  : [ON]" | tee -a log-install.txt
echo "   - IPtables                : [ON]" | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]" | tee -a log-install.txt
echo "   - IPv6                    : [OFF]" | tee -a log-install.txt
echo "   - Auto reboot time        : 05:00 GMT +7" | tee -a log-install.txt
echo "   - Auto backup data" | tee -a log-install.txt
echo "   - Restore data" | tee -a log-install.txt
echo "   - Auto delete expired accounts" | tee -a log-install.txt
echo "   - Complete management for all services" | tee -a log-install.txt
echo "   - White label supported" | tee -a log-install.txt
echo "   - Installation log --> /root/log-install.txt" | tee -a log-install.txt

echo "Rebooting in 15 seconds..."
sleep 15
rm -f setup.sh
reboot
