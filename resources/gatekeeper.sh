#!/bin/bash
CONFIG="/etc/gatekeeper/rules.conf"

while IFS=: read -r LOCAL REMOTEHOST REMOTEPORT; do
    [[ -z "$LOCAL" || "$LOCAL" =~ ^# ]] && continue
    echo "Launching forward: $LOCAL → $REMOTEHOST:$REMOTEPORT"
    socat TCP-LISTEN:"$LOCAL",fork TCP:"$REMOTEHOST":"$REMOTEPORT" &
done < "$CONFIG"

wait
