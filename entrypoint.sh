#!/usr/bin/env bash
set -euo pipefail

: "${PROXY_USER:?Falta PROXY_USER}"
: "${PROXY_PASS:?Falta PROXY_PASS}"

# asegura permisos correctos cuando /var/log/squid es un volumen
mkdir -p /var/log/squid /var/spool/squid
chown -R proxy:proxy /var/log/squid /var/spool/squid

# genera /etc/squid/passwd
htpasswd -bc /etc/squid/passwd "$PROXY_USER" "$PROXY_PASS"

exec squid -N -f /etc/squid/squid.conf
