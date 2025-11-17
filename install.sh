#!/bin/bash
set -e

echo "=== Creating Gatekeeper config directory ==="
sudo mkdir -p /etc/gatekeeper

echo "=== Creating /etc/gatekeeper/rules.conf ==="
sudo tee /etc/gatekeeper/rules.conf >/dev/null << 'EOF'
#GATEKEEPER-PORT:LAN-IP:TARGET-PORT
EOF

echo "=== Creating launcher script /usr/local/bin/gatekeeper.sh ==="
sudo tee /usr/local/bin/gatekeeper.sh >/dev/null << 'EOF'
#!/bin/bash
CONFIG="/etc/gatekeeper/rules.conf"

while IFS=: read -r LOCAL REMOTEHOST REMOTEPORT; do
    # Skip blank or commented lines
    [[ -z "$LOCAL" || "$LOCAL" =~ ^# ]] && continue

    echo "Launching forward: $LOCAL → $REMOTEHOST:$REMOTEPORT"
    socat TCP-LISTEN:"$LOCAL",fork TCP:"$REMOTEHOST":"$REMOTEPORT" &
done < "$CONFIG"

wait
EOF

sudo chmod +x /usr/local/bin/gatekeeper.sh

echo "=== Creating systemd service ==="
sudo tee /etc/systemd/system/gatekeeper.service >/dev/null << 'EOF'
[Unit]
Description=Gatekeeper Multi-Port Forwarder
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/gatekeeper.sh
Restart=always
RestartSec=2
User=nobody
Group=nogroup

[Install]
WantedBy=multi-user.target
EOF

echo "=== Reloading systemd and enabling service ==="
sudo systemctl daemon-reload
sudo systemctl enable --now gatekeeper

echo "============================================"
echo " Gatekeeper installed and running."
echo "============================================"

#Extra rule editing binary time
if [[ -x /usr/local/bin/vigatekeeper ]]; then
    echo "There exists a runnable file at /usr/local/bin/vigatekeeper."
    echo "The installer will not install the vigatekeeper command."
    echo "To edit rules, you can manually run:"
    echo "  sudo nano /etc/gatekeeper/rules.conf"
    echo "  sudo systemctl restart gatekeeper"
else
    sudo tee /usr/local/bin/vigatekeeper >/dev/null << 'EOF'
#!/bin/bash
sudo nano /etc/gatekeeper/rules.conf
sudo systemctl restart gatekeeper
EOF
    sudo chmod +x /usr/local/bin/vigatekeeper
fi

