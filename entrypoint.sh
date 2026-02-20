#!/usr/bin/env bash
set -euo pipefail

PROXY_USER="${PROXY_USER:-}"
PROXY_PASS="${PROXY_PASS:-}"

# asegura permisos correctos cuando /var/log/squid es un volumen
mkdir -p /var/log/squid /var/spool/squid
chown -R proxy:proxy /var/log/squid /var/spool/squid

mkdir -p /etc/squid/conf.d

if [[ -n "$PROXY_USER" && -n "$PROXY_PASS" ]]; then
  # genera /etc/squid/passwd y habilita auth basica
  htpasswd -bc /etc/squid/passwd "$PROXY_USER" "$PROXY_PASS"
  cat > /etc/squid/conf.d/auth.conf <<'EOF'
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic realm PrivateProxy
acl authenticated proxy_auth REQUIRED
EOF
  echo "http_access allow authenticated" > /etc/squid/conf.d/access.conf
elif [[ -z "$PROXY_USER" && -z "$PROXY_PASS" ]]; then
  # arranca sin credenciales
  rm -f /etc/squid/passwd
  cat > /etc/squid/conf.d/auth.conf <<'EOF'
# autenticacion deshabilitada
EOF
  echo "http_access allow all" > /etc/squid/conf.d/access.conf
else
  echo "Error: define PROXY_USER y PROXY_PASS juntos, o no definas ninguno." >&2
  exit 1
fi

exec squid -N -f /etc/squid/squid.conf
