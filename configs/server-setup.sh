#!/bin/bash

# Скрипт для настройки сервера для деплоя приложения
# Запустите этот скрипт один раз на вашем сервере перед первым деплоем
# Usage: sudo bash server-setup.sh

set -e

echo "🚀 Настройка сервера для Time Server API"
echo "=========================================="
echo ""

# Проверка root прав
if [ "$EUID" -ne 0 ]; then 
    echo "❌ Пожалуйста, запустите скрипт с правами root (sudo)"
    exit 1
fi

# Обновление системы
echo "📦 Обновление системы..."
apt update
apt upgrade -y

# Установка необходимых пакетов
echo "📦 Установка необходимых пакетов..."
apt install -y \
    curl \
    wget \
    git \
    vim \
    htop \
    ufw \
    fail2ban \
    nginx

# Установка Docker
echo "🐳 Установка Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    echo "✅ Docker установлен"
else
    echo "✅ Docker уже установлен"
fi

# Установка Docker Compose
echo "🐳 Установка Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo "✅ Docker Compose установлен"
else
    echo "✅ Docker Compose уже установлен"
fi

# Добавление пользователя в группу docker
echo "👤 Настройка прав пользователя..."
if [ ! -z "$SUDO_USER" ]; then
    usermod -aG docker $SUDO_USER
    echo "✅ Пользователь $SUDO_USER добавлен в группу docker"
fi

# Запуск и автозапуск Docker
echo "🔧 Настройка автозапуска Docker..."
systemctl enable docker
systemctl start docker

# Настройка UFW (файрвол)
echo "🔒 Настройка файрвола..."
ufw --force enable
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw allow 8000/tcp  # Приложение (опционально, если без Nginx)
echo "✅ Файрвол настроен"

# Настройка fail2ban для защиты от брутфорса
echo "🔒 Настройка fail2ban..."
systemctl enable fail2ban
systemctl start fail2ban

# Создание директории для приложения
echo "📁 Создание директорий..."
mkdir -p /opt/time-server
mkdir -p /var/log/time-server
if [ ! -z "$SUDO_USER" ]; then
    chown -R $SUDO_USER:$SUDO_USER /opt/time-server
    chown -R $SUDO_USER:$SUDO_USER /var/log/time-server
fi

# Настройка Nginx (опционально)
echo "🌐 Настройка Nginx..."
systemctl enable nginx
systemctl start nginx

# Создание базовой конфигурации Nginx
cat > /etc/nginx/sites-available/time-server << 'EOF'
server {
    listen 80;
    server_name _;
    
    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    location /health {
        proxy_pass http://localhost:8000/health;
        access_log off;
    }
}
EOF

# Активация конфигурации Nginx (закомментировано по умолчанию)
# ln -sf /etc/nginx/sites-available/time-server /etc/nginx/sites-enabled/
# rm -f /etc/nginx/sites-enabled/default
# nginx -t && systemctl reload nginx

echo ""
echo "✅ Сервер успешно настроен!"
echo ""
echo "📝 Следующие шаги:"
echo "   1. Настройте SSH ключ для GitHub Actions:"
echo "      ssh-keygen -t ed25519 -C 'github-actions'"
echo "      cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys"
echo ""
echo "   2. Добавьте секреты в GitHub:"
echo "      - SSH_HOST: IP адрес этого сервера"
echo "      - SSH_USERNAME: ваше имя пользователя"
echo "      - SSH_PRIVATE_KEY: содержимое ~/.ssh/id_ed25519"
echo ""
echo "   3. Если хотите использовать Nginx, раскомментируйте строки в скрипте"
echo "      и настройте домен в /etc/nginx/sites-available/time-server"
echo ""
echo "   4. Для SSL (Let's Encrypt):"
echo "      apt install certbot python3-certbot-nginx"
echo "      certbot --nginx -d your-domain.com"
echo ""
echo "   5. Перелогиньтесь для применения группы docker:"
echo "      exit && ssh user@server"
echo ""
echo "🚀 Теперь можно деплоить через GitHub Actions!"
