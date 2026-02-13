# 📝 Шпаргалка по командам

Краткая справка по наиболее используемым командам для работы с проектом.

## 🚀 Быстрый деплой

```bash
# Простой деплой
git add .
git commit -m "Deploy update"
git push origin main

# Деплой с версией
git tag v1.0.0
git push origin v1.0.0
```

## 🐳 Docker локально

```bash
# Собрать и запустить
docker build -t time-server .
docker run -d -p 8000:8000 --name time-server time-server

# Остановить и удалить
docker stop time-server
docker rm time-server

# Логи
docker logs -f time-server

# Очистка
docker system prune -a
```

## 🔐 SSH на сервер

```bash
# Подключение
ssh user@your-server-ip

# Проверка контейнера
docker ps
docker logs time-server-app

# Перезапуск контейнера
docker restart time-server-app
```

## 📦 GHCR (GitHub Container Registry)

```bash
# Логин
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Pull образа
docker pull ghcr.io/username/actions:latest

# Push образа
docker tag time-server ghcr.io/username/actions:latest
docker push ghcr.io/username/actions:latest
```

## 🧪 Тестирование API

```bash
# Health check
curl http://localhost:8000/health

# Время
curl http://localhost:8000/time | jq .

# Дата
curl http://localhost:8000/date | jq .

# Документация
open http://localhost:8000/docs  # macOS
start http://localhost:8000/docs # Windows
```

## 🔧 GitHub Actions

```bash
# Проверка workflow
# GitHub → Actions → выбрать run

# Повторный запуск
# GitHub → Actions → Re-run all jobs

# Секреты
# Settings → Secrets and variables → Actions
```

## 🌐 Nginx

```bash
# Проверка конфигурации
sudo nginx -t

# Перезагрузка
sudo systemctl reload nginx

# Логи
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log
```

## 🔒 SSL (Let's Encrypt)

```bash
# Установка
sudo apt install certbot python3-certbot-nginx

# Получение сертификата
sudo certbot --nginx -d your-domain.com

# Обновление
sudo certbot renew

# Тест обновления
sudo certbot renew --dry-run
```

## 📊 Мониторинг

```bash
# Статус контейнера
docker ps
docker stats time-server-app

# Использование диска
docker system df
df -h

# Процессы
htop

# Порты
sudo lsof -i :8000
sudo netstat -tulpn | grep :8000
```

## 🛠️ Troubleshooting

```bash
# Контейнер не запускается
docker logs time-server-app
docker inspect time-server-app

# Порт занят
sudo lsof -i :8000
sudo kill -9 PID

# Очистка Docker
docker container prune
docker image prune
docker system prune -a

# SSH не работает
ssh -vvv user@server  # debug mode
cat ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

## ⚡ Быстрые действия

### Откат на предыдущую версию

```bash
ssh user@server
docker stop time-server-app && docker rm time-server-app
docker pull ghcr.io/username/actions:v1.0.0
docker run -d --name time-server-app -p 8000:8000 ghcr.io/username/actions:v1.0.0
```

### Просмотр переменных окружения контейнера

```bash
docker inspect time-server-app | jq '.[0].Config.Env'
```

### Зайти внутрь контейнера

```bash
docker exec -it time-server-app bash
```

### Копирование файлов из контейнера

```bash
docker cp time-server-app:/app/logs/app.log ./
```

### Проверка здоровья приложения

```bash
# На сервере
curl http://localhost:8000/health

# Извне
curl http://your-domain.com/health
```

## 📱 Алиасы (добавьте в ~/.bashrc)

```bash
# Docker
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dlogs='docker logs -f'
alias dexec='docker exec -it'

# Docker Compose
alias dc='docker-compose'
alias dcup='docker-compose up -d'
alias dcdown='docker-compose down'
alias dclogs='docker-compose logs -f'

# SSH
alias server='ssh user@your-server-ip'

# Использование
dps                              # docker ps
dlogs time-server-app            # docker logs -f time-server-app
dexec time-server-app bash       # docker exec -it time-server-app bash
```

## 🎯 Полезные однострочники

```bash
# Удалить все остановленные контейнеры
docker rm $(docker ps -aq -f status=exited)

# Удалить все образы без тега
docker rmi $(docker images -f "dangling=true" -q)

# Найти все контейнеры, использующие образ
docker ps -a --filter ancestor=time-server

# Получить IP контейнера
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' time-server-app

# Получить порты контейнера
docker port time-server-app

# Мониторинг ресурсов всех контейнеров
docker stats --no-stream

# Логи за последний час
docker logs --since 1h time-server-app

# Последние 100 строк логов
docker logs --tail 100 time-server-app

# Размер контейнера
docker ps -s

# Экспорт контейнера
docker export time-server-app > time-server.tar

# История образа
docker history time-server
```

## 📖 Документация

| Файл | Описание |
|------|----------|
| [QUICKSTART.md](QUICKSTART.md) | Быстрый старт за 5 минут |
| [README.md](README.md) | Основная документация |
| [COMMANDS.md](COMMANDS.md) | Подробные команды |
| [.github/DEPLOYMENT_SETUP.md](.github/DEPLOYMENT_SETUP.md) | Настройка деплоя |
| [.github/README.md](.github/README.md) | О workflows |
| [configs/SSL_SETUP.md](configs/SSL_SETUP.md) | Настройка SSL |

---

**💡 Совет:** Сохраните эту страницу в закладки для быстрого доступа!
