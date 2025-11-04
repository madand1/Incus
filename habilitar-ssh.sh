#!/usr/bin/env bash
# Script para configurar claves SSH en contenedores Incus
# Autor: Andrés Morales (TFG)

for c in web01 db01 client01; do
  echo "🔑 Configurando clave en $c..."
  incus exec $c -- mkdir -p /root/.ssh
  incus file push /home/andy/.ssh/id_ed25519.pub $c/root/.ssh/authorized_keys
  incus exec $c -- chown root:root /root/.ssh/authorized_keys
  incus exec $c -- chmod 600 /root/.ssh/authorized_keys
  incus exec $c -- chmod 700 /root/.ssh
done

echo "✅ Claves SSH configuradas correctamente en web01, db01 y client01"
