# 📋 Полезные команды для работы с проектом

## 🐳 Docker команды

### Локальная разработка

```bash
# Сборка образа локально
docker build -t time-server .

# Запуск контейнера
docker run -d -p 8000:8000 --name time-server time-server

# Просмотр логов
docker logs time-server
docker logs -f time-server  # следить за логами в реальном времени

# Остановка и удаление контейнера
docker stop time-server
docker rm time-server

# Зайти внутрь контейнера
docker exec -it time-server bash
```

### Очистка Docker

```bash
# Удалить все остановленные контейнеры
docker container prune

# Удалить неиспользуемые образы
docker image prune

# Удалить всё неиспользуемое (контейнеры, образы, сети, volumes)
docker system prune -a

# Посмотреть использование места
docker system df
```

## 📦 GitHub Container Registry (GHCR)

### Локальная работа с GHCR

```bash
# 1. Создать Personal Access Token (PAT)
# GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
# Права: write:packages, read:packages, delete:packages

# 2. Сохранить токен в переменную
export GITHUB_TOKEN=your_token_here

# 3. Логин в GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin

# 4. Пометить образ для GHCR
docker tag time-server ghcr.io/YOUR_USERNAME/actions:latest

# 5. Запушить образ в GHCR
docker push ghcr.io/YOUR_USERNAME/actions:latest

# 6. Скачать образ из GHCR
docker pull ghcr.io/YOUR_USERNAME/actions:latest
```

### Сделать образ публичным

1. Перейдите на GitHub → Your profile → Packages
2. Выберите ваш пакет
3. Package settings → Change visibility → Public

## 🚀 Деплой на сервер

### Ручной деплой через SSH

```bash
# 1. Подключиться к серверу
ssh user@your-server-ip

# 2. Логин в GHCR на сервере
echo YOUR_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin

# 3. Скачать образ
docker pull ghcr.io/YOUR_USERNAME/actions:latest

# 4. Остановить старый контейнер
docker stop time-server-app || true
docker rm time-server-app || true

# 5. Запустить новый контейнер
docker run -d \
  --name time-server-app \
  --restart unless-stopped \
  -p 8000:8000 \
  ghcr.io/YOUR_USERNAME/actions:latest

# 6. Проверить статус
docker ps
docker logs time-server-app
curl http://localhost:8000/health
```

### Деплой через Docker Compose

```bash
# 1. Подключиться к серверу
ssh user@your-server-ip

# 2. Создать папку для проекта
mkdir -p ~/time-server
cd ~/time-server

# 3. Создать или скопировать docker-compose.yml
# (используйте файл из репозитория)

# 4. Установить переменную окружения
export GITHUB_REPOSITORY=YOUR_USERNAME/actions

# 5. Логин в GHCR
echo YOUR_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin

# 6. Запустить через Docker Compose
docker-compose pull
docker-compose up -d

# 7. Проверить статус
docker-compose ps
docker-compose logs

# 8. Остановить
docker-compose down

# 9. Перезапустить
docker-compose restart
```

## 🔐 SSH команды

### Генерация SSH ключа

```bash
# Генерация нового SSH ключа для GitHub Actions
ssh-keygen -t ed25519 -C "github-actions" -f ~/.ssh/github_actions_key

# Копирование публичного ключа на сервер
ssh-copy-id -i ~/.ssh/github_actions_key.pub user@your-server

# Или вручную:
cat ~/.ssh/github_actions_key.pub
# Затем на сервере:
echo "ПУБЛИЧНЫЙ_КЛЮЧ" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

### Тестирование SSH подключения

```bash
# Тест подключения с конкретным ключом
ssh -i ~/.ssh/github_actions_key user@your-server

# Проверка доступа Docker на сервере
ssh user@your-server "docker ps"

# Выполнение команды на сервере
ssh user@your-server "docker ps && curl http://localhost:8000/health"
```

## 🔧 Git и GitHub Actions

### Локальная работа с Git

```bash
# Создать новый коммит и запустить деплой
git add .
git commit -m "Update application"
git push origin main

# Создать тег для версионирования
git tag v1.0.0
git push origin v1.0.0

# Посмотреть статус GitHub Actions
# GitHub → Actions → выбрать workflow
```

### Работа с секретами

```bash
# Получить приватный SSH ключ для GitHub Secrets
cat ~/.ssh/github_actions_key

# Скопировать содержимое и добавить в:
# GitHub → Repository → Settings → Secrets and variables → Actions → New secret
```

## 🧪 Тестирование

### Локальное тестирование

```bash
# Bash (Linux/macOS)
chmod +x scripts/test-docker.sh
./scripts/test-docker.sh

# PowerShell (Windows)
.\scripts\test-docker.ps1
```

### Тестирование API

```bash
# Health check
curl http://localhost:8000/health

# Получить текущее время
curl http://localhost:8000/time

# Получить текущую дату
curl http://localhost:8000/date

# Получить документацию API
# Открыть в браузере: http://localhost:8000/docs
```

### Тестирование с jq (красивый JSON)

```bash
# Установка jq (если нет)
# macOS: brew install jq
# Ubuntu: sudo apt install jq
# Windows: choco install jq

# Использование
curl -s http://localhost:8000/time | jq .
curl -s http://localhost:8000/date | jq '.date, .day_of_week_ru'
```

## 📊 Мониторинг

### Мониторинг на сервере

```bash
# Статус контейнера
docker ps
docker stats time-server-app

# Использование ресурсов
docker stats --no-stream

# Логи (последние 100 строк)
docker logs --tail=100 time-server-app

# Логи в реальном времени
docker logs -f time-server-app

# Проверка health check
curl http://localhost:8000/health
```

### Мониторинг с Docker Compose

```bash
cd ~/time-server

# Статус всех сервисов
docker-compose ps

# Логи всех сервисов
docker-compose logs

# Логи конкретного сервиса
docker-compose logs time-server

# Использование ресурсов
docker-compose top
```

## 🛠️ Troubleshooting

### Проблемы с портом

```bash
# Узнать, какой процесс использует порт 8000
# Linux/macOS:
lsof -i :8000
sudo netstat -tulpn | grep :8000

# Windows PowerShell:
netstat -ano | findstr :8000
```

### Проблемы с Docker

```bash
# Перезапуск Docker
sudo systemctl restart docker  # Linux
# или для Windows: перезапустить Docker Desktop

# Проверка логов Docker
sudo journalctl -u docker

# Проверка версии
docker --version
docker-compose --version
```

### Проблемы с GitHub Actions

```bash
# Просмотр логов workflow
# GitHub → Actions → выбрать workflow run → посмотреть логи

# Проверка секретов
# GitHub → Settings → Secrets and variables → Actions

# Повторный запуск workflow
# GitHub → Actions → выбрать failed run → Re-run all jobs
```

## 📝 Полезные алиасы (добавить в ~/.bashrc или ~/.zshrc)

```bash
# Добавьте в ~/.bashrc или ~/.zshrc
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dlogs='docker logs -f'
alias dstop='docker stop'
alias drm='docker rm'
alias drmi='docker rmi'
alias dprune='docker system prune -a'

# Использование
dps              # docker ps
dlogs container  # docker logs -f container
```

## 🌐 Полезные ссылки

- **Swagger UI:** http://localhost:8000/docs
- **ReDoc:** http://localhost:8000/redoc
- **Health Check:** http://localhost:8000/health
- **GitHub Actions:** https://github.com/YOUR_USERNAME/actions/actions
- **GitHub Packages:** https://github.com/YOUR_USERNAME?tab=packages
