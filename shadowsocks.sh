#!/bin/bash
set -e

# Actualización e instalación de paquetes necesarios
apt-get -y update
apt-get -y install ufw shadowsocks-libev simple-obfs openssl curl

# Configuración del firewall
ufw allow 443
ufw allow 22
ufw --force enable

# Obtener IP pública y generar contraseña
ip_publica=$(curl -4 -s ifconfig.me)
clave=$(openssl rand -base64 16)

# Crear nuevo archivo de configuración
cat > /etc/shadowsocks-libev/config.json <<EOF
{
    "server": ["$ip_publica"],
    "mode": "tcp_and_udp",
    "server_port": 443,
    "local_port": 1080,
    "password": "$clave",
    "timeout": 3000,
    "method": "aes-256-gcm",
    "plugin": "obfs-server",
    "plugin_opts": "obfs=tls;obfs-host=www.bing.com"
}
EOF

# Reiniciar el servicio
systemctl restart shadowsocks-libev
# Limpiar la pantalla
clear
# Mostrar datos al usuario
echo "==================="
echo "Datos del servidor:"
echo "==================="
echo "IP: $ip_publica"
echo "Puerto: 443"
echo "Clave: $clave"
echo "Método: AES-256-GCM"
echo ""
echo "============================"
echo "Datos de Simple Obfuscation:"
echo "============================"
echo "Obfuscation Wrapper: tls"
echo "Hostname: www.bing.com"

# Guardar datos en archivo
cat > /root/datos_shadowsocks.txt <<EOF
IP: $ip_publica
Puerto: 443
Clave: $clave
Método: AES-256-GCM
Obfs: tls
Host: www.bing.com
EOF
