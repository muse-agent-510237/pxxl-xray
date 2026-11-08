#!/bin/bash
set -e
cd /tmp
if [ ! -f /tmp/xray ]; then
curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip -o /tmp/xray.zip xray -d /tmp || python3 -c "import zipfile; zipfile.ZipFile('/tmp/xray.zip').extract('xray','/tmp')"
chmod +x /tmp/xray
fi
cat > /tmp/c.json <<EOF
{"log":{"loglevel":"warning"},"inbounds":[{"listen":"0.0.0.0","port":${PORT},"protocol":"vless","settings":{"clients":[{"id":"${UUID}","flow":""}],"decryption":"none"},"streamSettings":{"network":"ws","security":"none","wsSettings":{"path":"/${UUID}"}}}] ,"outbounds":[{"protocol":"freedom","settings":{"domainStrategy":"UseIPv4"}}]}
EOF
exec /tmp/xray run -config /tmp/c.json
