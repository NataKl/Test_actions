# 🔒 Настройка SSL сертификата (Let's Encrypt)

Это руководство поможет вам настроить бесплатный SSL сертификат для вашего приложения.

## Предварительные требования

- ✅ Домен направлен на IP вашего сервера (A-запись в DNS)
- ✅ Nginx установлен и работает
- ✅ Порты 80 и 443 открыты в файрволе

## 🚀 Быстрая установка

### Шаг 1: Установка Certbot

```bash
# Подключитесь к серверу
ssh user@your-server

# Установите Certbot
sudo apt update
sudo apt install certbot python3-certbot-nginx -y
```

### Шаг 2: Получение сертификата

```bash
# Замените your-domain.com на ваш домен
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

Certbot автоматически:
- Получит сертификат
- Настроит Nginx
- Настроит автообновление

### Шаг 3: Проверка

```bash
# Проверьте конфигурацию Nginx
sudo nginx -t

# Перезагрузите Nginx
sudo systemctl reload nginx

# Откройте в браузере
# https://your-domain.com
```

## 📋 Ручная настройка Nginx для SSL

Если вы хотите настроить вручную, используйте эту конфигурацию:

```nginx
# /etc/nginx/sites-available/time-server

# Редирект с HTTP на HTTPS
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;
    
    # Let's Encrypt ACME Challenge
    location /.well-known/acme-challenge/ {
        root /var/www/html;
    }
    
    # Редирект на HTTPS
    location / {
        return 301 https://$server_name$request_uri;
    }
}

# HTTPS конфигурация
server {
    listen 443 ssl http2;
    server_name your-domain.com www.your-domain.com;
    
    # SSL сертификаты
    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
    
    # SSL настройки
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384';
    ssl_prefer_server_ciphers off;
    
    # HSTS (опционально, включайте только если уверены)
    # add_header Strict-Transport-Security "max-age=63072000" always;
    
    # Логи
    access_log /var/log/nginx/time-server-access.log;
    error_log /var/log/nginx/time-server-error.log;
    
    # Проксирование на приложение
    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # Таймауты
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
    
    # Health check
    location /health {
        proxy_pass http://localhost:8000/health;
        access_log off;
    }
}
```

## 🔄 Автоматическое обновление сертификата

Certbot автоматически настраивает cron job для обновления сертификатов.

### Проверка автообновления

```bash
# Проверка таймера systemd
sudo systemctl status certbot.timer

# Тест обновления (сухой прогон)
sudo certbot renew --dry-run
```

### Ручное обновление

```bash
# Обновить все сертификаты
sudo certbot renew

# Обновить конкретный сертификат
sudo certbot renew --cert-name your-domain.com
```

## 🌐 Настройка DNS

Убедитесь, что ваш домен правильно настроен:

### A-запись

```
Type: A
Name: @
Value: YOUR_SERVER_IP
TTL: 3600
```

### WWW поддомен

```
Type: A
Name: www
Value: YOUR_SERVER_IP
TTL: 3600
```

Или используйте CNAME:

```
Type: CNAME
Name: www
Value: your-domain.com
TTL: 3600
```

## ✅ Проверка SSL

### Онлайн инструменты

- [SSL Labs](https://www.ssllabs.com/ssltest/) - тест безопасности SSL
- [Why No Padlock](https://www.whynopadlock.com/) - проверка смешанного контента

### Командная строка

```bash
# Проверка SSL сертификата
openssl s_client -connect your-domain.com:443 -servername your-domain.com

# Проверка срока действия
echo | openssl s_client -servername your-domain.com -connect your-domain.com:443 2>/dev/null | openssl x509 -noout -dates

# Тест HTTPS запроса
curl -I https://your-domain.com
```

## 🔧 Troubleshooting

### Ошибка "Failed to bind to port 80"

```bash
# Проверьте, что Nginx не занимает порт
sudo systemctl stop nginx

# Попробуйте снова
sudo certbot --nginx -d your-domain.com

# Запустите Nginx
sudo systemctl start nginx
```

### Ошибка "DNS resolution failed"

```bash
# Проверьте DNS
nslookup your-domain.com
dig your-domain.com

# Подождите несколько минут после изменения DNS
```

### Сертификат не обновляется автоматически

```bash
# Проверьте логи
sudo journalctl -u certbot.timer

# Проверьте cron job
sudo crontab -l

# Добавьте вручную в cron (если нет)
sudo crontab -e
# Добавьте:
0 0,12 * * * certbot renew --quiet --post-hook "systemctl reload nginx"
```

## 🛡️ Дополнительная безопасность

### Настройка Mozilla SSL Configuration

Используйте [Mozilla SSL Configuration Generator](https://ssl-config.mozilla.org/) для генерации оптимальной конфигурации.

### HTTP/2 и HTTP/3

```nginx
# HTTP/2 (уже включен в примере)
listen 443 ssl http2;

# HTTP/3 (экспериментально)
listen 443 quic reuseport;
add_header Alt-Svc 'h3=":443"; ma=86400';
```

### Security Headers

```nginx
# Добавьте в server block
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "no-referrer-when-downgrade" always;
```

## 📚 Полезные ссылки

- [Certbot Documentation](https://certbot.eff.org/)
- [Let's Encrypt](https://letsencrypt.org/)
- [Nginx SSL Configuration](https://nginx.org/en/docs/http/configuring_https_servers.html)
- [Mozilla SSL Configuration Generator](https://ssl-config.mozilla.org/)

## 🎯 Checklist

- [ ] Домен направлен на IP сервера
- [ ] Порты 80 и 443 открыты
- [ ] Certbot установлен
- [ ] Сертификат получен
- [ ] Nginx настроен для HTTPS
- [ ] Редирект с HTTP на HTTPS работает
- [ ] Автообновление сертификата настроено
- [ ] SSL проверен через SSL Labs
- [ ] Приложение доступно по HTTPS

---

**💡 Совет:** После настройки SSL обновите GitHub Actions workflow, чтобы проверять HTTPS endpoint вместо HTTP в health check.
