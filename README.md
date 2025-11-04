# 🎓 TFG – Automatización y despliegue de un laboratorio reproducible con Ansible e Incus

## 📖 Descripción
Este Trabajo Fin de Grado tiene como objetivo diseñar, automatizar y documentar un laboratorio completo para el despliegue de aplicaciones web en entornos virtualizados.  
El proyecto se centra en la creación de un escenario reproducible con **Incus (LXD fork)** y **Ansible**, donde se integran servicios de red, bases de datos y aplicaciones web.

## 🚀 Características principales
- **Automatización total**: scripts en Bash y playbooks de Ansible para crear, configurar y validar contenedores (`web01`, `db01`, `client01`).
- **Despliegue de WordPress**: instalación de Apache, PHP y WordPress en `web01`, con conexión a MariaDB en `db01`.
- **Base de datos remota**: configuración de MariaDB para aceptar conexiones externas, creación de usuarios y permisos específicos.
- **Inventario dinámico**: generación automática de `host.ini` con las IPs de los contenedores.
- **Troubleshooting documentado**: cada incidencia (puertos, SSH, MariaDB, WordPress) se convierte en un bloque académico reproducible.
- **Validación**: pruebas de conectividad y acceso web desde `client01`.

---

# 📦 Incus: gestor de contenedores y máquinas virtuales

## ¿Qué es Incus?
Incus es un sistema de gestión de contenedores y máquinas virtuales desarrollado como bifurcación de LXD por la comunidad de Linux Containers.  
Permite ejecutar sistemas Linux completos en contenedores ligeros o en máquinas virtuales, ofreciendo una experiencia similar a la de una nube privada en entornos locales o de laboratorio.

## ¿Para qué sirve?
- Virtualización ligera mediante contenedores Linux.  
- Ejecución de máquinas virtuales con kernel propio.  
- Creación de entornos reproducibles para pruebas, desarrollo y docencia.  
- Gestión centralizada a través de la CLI `incus` o de su API REST.  
- Compatibilidad con múltiples distribuciones (Debian, Ubuntu, Fedora, Alpine, entre otras).  

En este proyecto, Incus se utiliza para crear un laboratorio reproducible con tres contenedores:
- `web01` → Apache, PHP y WordPress.  
- `db01` → MariaDB.  
- `client01` → pruebas de conectividad y validación.  
