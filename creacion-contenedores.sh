#!/usr/bin/env bash
# Script para recrear contenedores del laboratorio TFG
# Autor: Andrés Morales

# 1. Borrar contenedores si existen
for c in web01 db01 client01; do
  if incus list --format csv -c n | grep -q "^$c$"; then
    echo "🗑️ Eliminando contenedor $c..."
    incus delete -f $c
  fi
done

# 2. Crear contenedores nuevos en la red br0
echo "🚀 Creando contenedores..."
incus launch images:debian/12 web01 -n br0
incus launch images:debian/12 db01 -n br0
incus launch images:debian/12 client01 -n br0

echo "✅ Contenedores recreados: web01, db01, client01"
