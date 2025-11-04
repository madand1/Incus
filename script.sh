#!/usr/bin/env bash
# Script maestro para preparar contenedores e inventario dinámico
# Autor: Andrés Morales (TFG)

OUT="inventario/host.ini"
mkdir -p inventario

# 1. Crear contenedores si no existen
for c in web01 db01 client01; do
  if ! incus list --format csv -c n | grep -q "^$c$"; then
    echo "🚀 Creando contenedor $c..."
    incus launch images:debian/12 $c -n br0
  else
    echo "ℹ️ Contenedor $c ya existe"
  fi
done

# 2. Instalar SSH y Python en todos los contenedores
for c in web01 db01 client01; do
  echo "📦 Instalando SSH y Python en $c..."
  incus exec $c -- apt update
  incus exec $c -- apt install -y openssh-server python3
  incus exec $c -- systemctl enable --now ssh
done

# 3. Configurar sshd_config para permitir root con clave
for c in web01 db01 client01; do
  echo "🔧 Ajustando configuración SSH en $c..."
  incus exec $c -- sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
  incus exec $c -- sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
  incus exec $c -- systemctl restart ssh
done

# 4. Copiar tu clave pública con permisos correctos
for c in web01 db01 client01; do
  echo "🔑 Configurando clave en $c..."
  incus exec $c -- mkdir -p /root/.ssh
  incus file push /home/andy/.ssh/id_ed25519.pub $c/root/.ssh/authorized_keys
  incus exec $c -- chown root:root /root/.ssh/authorized_keys
  incus exec $c -- chmod 600 /root/.ssh/authorized_keys
  incus exec $c -- chmod 700 /root/.ssh
done

# 5. Función para obtener la IP de la red br0 (10.10.10.x)
get_ip() {
  incus list "$1" --format csv -c 4 | grep -Eo '10\.10\.10\.[0-9]+'
}

WEB_IP=$(get_ip web01)
DB_IP=$(get_ip db01)
CLIENT_IP=$(get_ip client01)

# 6. Generar inventario dinámico para Ansible
cat > "$OUT" <<EOF
[web]
web01 ansible_host=$WEB_IP ansible_user=root ansible_connection=ssh

[db]
db01 ansible_host=$DB_IP ansible_user=root ansible_connection=ssh

[client]
client01 ansible_host=$CLIENT_IP ansible_user=root ansible_connection=ssh

[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_private_key_file=/home/andy/.ssh/id_ed25519
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

echo "✅ Inventario generado en $OUT"
cat "$OUT"
