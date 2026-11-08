#!/bin/bash
set -e
if [ ! -f ./xray ]; then
unzip -o ./browser-download-20261108T111711.565269987Z-0-Xray-linux-64.zip xray -d .
chmod +x ./xray
fi
cat > /tmp/c.json <<EOF
{"log":{"loglevel":"warning"},"inbounds":[{"listen":"0.0.0.0","port":${PORT},"protocol":"vless","settings":{"clients":[{"id":"${UUID}","flow":""}],"decryption":"none"},"streamSettings":{"network":"ws","security":"none","wsSettings":{"path":"/${UUID}"}}}] ,"outbounds":[{"protocol":"freedom","settings":{"domainStrategy":"UseIPv4"}}]}
EOF
exec ./xray run -config /tmp/c.json
