#!/bin/bash
# Script para forzar que MariaDB escuche en 0.0.0.0

CONF="/etc/mysql/mariadb.conf.d/50-server.cnf"

# Verificar que el archivo existe
if [ ! -f "$CONF" ]; then
  echo "No se encontró $CONF, revisa la ruta de configuración de MariaDB."
  exit 1
fi

# Si existe bind-address, lo reemplaza
if grep -q "^bind-address" "$CONF"; then
    sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' "$CONF"
else
    # Si no existe, lo añade bajo la sección [mysqld]
    sed -i '/^

\[mysqld\]

/a bind-address = 0.0.0.0' "$CONF"
fi

# Reiniciar MariaDB
systemctl restart mariadb

# Verificar resultado
ss -tlnp | grep 3306
