#!/bin/bash
set -e
if [ -x ./xray ]; then
XRAY=./xray
elif [ -x /tmp/xray ]; then
XRAY=/tmp/xray
else
cd /tmp
curl -L --fail --retry 3 --connect-timeout 15 --max-time 180 -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip -o /tmp/xray.zip xray -d /tmp
chmod +x /tmp/xray
XRAY=/tmp/xray
fi
cat > /tmp/c.json <<EOF
{"log":{"loglevel":"warning"},"inbounds":[{"listen":"0.0.0.0","port":${PORT},"protocol":"vless","settings":{"clients":[{"id":"${UUID}","flow":""}],"decryption":"none"},"streamSettings":{"network":"ws","security":"none","wsSettings":{"path":"/${UUID}"}}}] ,"outbounds":[{"protocol":"freedom","settings":{"domainStrategy":"UseIPv4"}}]}
EOF
exec $XRAY run -config /tmp/c.json
