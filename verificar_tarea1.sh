#!/bin/bash

# === CONFIGURACIÓN ===
GRUPOS=("diseño" "desarrollo" "admin")
USUARIOS_DISEÑO=("ana" "carlos")
USUARIOS_DESARROLLO=("luis" "marta")
USUARIOS_ADMIN=("pablo")
SUPERVISOR="supervisor"
CARPETAS=("/proyectos/diseño" "/proyectos/desarrollo" "/proyectos/admin")
ARCHIVO="readme.txt"

echo "🔍 Verificación de entorno de usuarios, grupos y permisos"
echo "----------------------------------------------------------"

# === 1. Verificar existencia de grupos ===
echo "📂 Verificando grupos..."
for grupo in "${GRUPOS[@]}"; do
    if getent group "$grupo" > /dev/null; then
        echo "✅ Grupo '$grupo' existe."
    else
        echo "❌ Grupo '$grupo' NO existe."
    fi
done

# === 2. Verificar usuarios y grupos ===
echo -e "\n👤 Verificando usuarios y su pertenencia a grupos..."
for user in "${USUARIOS_DISEÑO[@]}"; do
    id "$user" | grep -q "diseño" && echo "✅ Usuario '$user' pertenece a diseño." || echo "❌ Usuario '$user' no pertenece a diseño."
done
for user in "${USUARIOS_DESARROLLO[@]}"; do
    id "$user" | grep -q "desarrollo" && echo "✅ Usuario '$user' pertenece a desarrollo." || echo "❌ Usuario '$user' no pertenece a desarrollo."
done
for user in "${USUARIOS_ADMIN[@]}"; do
    id "$user" | grep -q "admin" && echo "✅ Usuario '$user' pertenece a admin." || echo "❌ Usuario '$user' no pertenece a admin."
done
id "$SUPERVISOR" &> /dev/null && echo "✅ Usuario '$SUPERVISOR' existe." || echo "❌ Usuario '$SUPERVISOR' no existe."

# === 3. Verificar carpetas y permisos ===
echo -e "\n📁 Verificando directorios y permisos..."
for carpeta in "${CARPETAS[@]}"; do
    if [ -d "$carpeta" ]; then
        ls -ld "$carpeta"
        echo "✅ Carpeta '$carpeta' existe."
    else
        echo "❌ Carpeta '$carpeta' NO existe."
    fi
done

# === 4. Verificar archivos de prueba y accesos básicos ===
echo -e "\n📄 Verificando existencia de archivos de prueba..."
for carpeta in "${CARPETAS[@]}"; do
    if [ -f "$carpeta/$ARCHIVO" ]; then
        echo "✅ $ARCHIVO existe en $carpeta"
    else
        echo "❌ $ARCHIVO no existe en $carpeta"
    fi
done

# === 5. Verificar acceso del supervisor (ACL o permisos) ===
echo -e "\n🔐 Verificando acceso del usuario 'supervisor'..."
for carpeta in "${CARPETAS[@]}"; do
    echo "📁 Verificando acceso a $carpeta"
    getfacl "$carpeta" | grep "$SUPERVISOR" &> /dev/null
    if [ $? -eq 0 ]; then
        echo "✅ ACL configurada para '$SUPERVISOR' en $carpeta"
    else
        echo "⚠️ No se encontró ACL para '$SUPERVISOR' en $carpeta (puede tener acceso por grupo o no tener acceso)"
    fi
done

echo -e "\n✅ Verificación completada."
