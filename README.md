# Proxy Squid en Docker

Proxy HTTP/HTTPS con autenticacion basica usando Squid, listo para correr en
contenedor Docker con credenciales por variables de entorno.

## Requisitos
- Docker
- Docker Compose (plugin `docker compose`)

## Uso rapido
1) Copiar y editar `.env`:
```
cp .env.example .env
```
2) Build y run:
```
docker compose up -d --build
```
3) Probar con curl (usa las credenciales de `.env`):
```
curl -x http://usuario:contrasena@localhost:3128 https://example.com -I
```
4) Ver logs:
```
docker compose logs -f squid
```
5) Detener:
```
docker compose down
```

## Configuracion
- Credenciales: editar `PROXY_USER` y `PROXY_PASS` en `.env`.
- Puerto: `http_port 3128` en `squid.conf` y el mapeo `3128:3128` en `compose.yml`.
- Politica de puertos: en `squid.conf` solo se permiten 80/443 por defecto.
  Si necesitas mas puertos, agrega reglas en `Safe_ports` y `SSL_ports`.

## Estructura del proyecto
```
.
├── .env.example      # plantilla de variables de entorno
├── .env              # variables locales (ignorado por git)
├── compose.yml        # definicion del servicio y volumen de logs
├── Dockerfile         # imagen con squid y utilidades
├── entrypoint.sh      # crea /etc/squid/passwd y arranca squid
└── squid.conf         # configuracion de squid
```

## Notas de seguridad
- Cambia las credenciales por defecto antes de exponer el proxy.
- Si solo lo usaras localmente, limita el bind a `127.0.0.1:3128:3128`.
- Considera restringir por IP con ACLs en `squid.conf`.

## Logs
Los logs se guardan en el volumen `squid_logs` montado en `/var/log/squid`.
El `entrypoint.sh` asegura permisos correctos para que Squid pueda escribirlos.
