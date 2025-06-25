#!/bin/bash

# Script para configurar el entorno de desarrollo de Jekyll

echo "🚀 Configurando entorno de desarrollo Jekyll..."

# Verificar que docker y docker-compose estén instalados
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose no está instalado"
    exit 1
fi

# Construir la imagen
echo "🔨 Construyendo imagen Docker..."
docker-compose build

# Crear los volúmenes si no existen
echo "📦 Configurando volúmenes persistentes..."
docker-compose up --no-start

echo "✅ Configuración completada!"
echo ""
echo "Comandos útiles:"
echo "  docker-compose up -d          # Iniciar contenedor en background"
echo "  docker-compose exec jekyll-dev bash  # Entrar al contenedor"
echo "  docker-compose logs -f        # Ver logs"
echo "  docker-compose down           # Detener contenedor"
echo ""
echo "Dentro del contenedor:"
echo "  bundle install               # Instalar dependencias"
echo "  bundle exec jekyll serve --host 0.0.0.0  # Servir sitio"
echo "  bundle exec jekyll serve --host 0.0.0.0 --livereload  # Con live reload"