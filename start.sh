#!/bin/bash
set -e
PORT=${PORT:-8080}
ZIP="./browser-download-20261108T111711.565269987Z-0-Xray-linux-64.zip"
BIN_DIR="/tmp/xray-bin"
mkdir -p "$BIN_DIR"
if [ ! -x "$BIN_DIR/xray" ]; then
  echo "[start] extracting xray to $BIN_DIR"
  if ! unzip -o "$ZIP" xray -d "$BIN_DIR" 2>/tmp/unzip.log; then
    echo "[start] unzip -d failed, falling back to unzip -p"
    cat /tmp/unzip.log || true
    unzip -p "$ZIP" xray > "$BIN_DIR/xray"
  fi
  chmod +x "$BIN_DIR/xray"
fi
ls -l "$BIN_DIR/xray"
cat > /tmp/c.json <<EOF
{"log":{"loglevel":"warning"},"inbounds":[{"listen":"0.0.0.0","port":${PORT},"protocol":"vless","settings":{"clients":[{"id":"${UUID}","flow":""}],"decryption":"none"},"streamSettings":{"network":"ws","security":"none","wsSettings":{"path":"/${UUID}"}}}],"outbounds":[{"protocol":"freedom","settings":{"domainStrategy":"UseIPv4"}}]}
EOF
echo "[start] launching xray on 0.0.0.0:${PORT}"
exec "$BIN_DIR/xray" run -config /tmp/c.json
