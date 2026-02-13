# ⚡ Быстрый старт - Деплой за 5 минут

Это руководство поможет вам настроить автоматический деплой вашего приложения на сервер за 5 минут.

## 📋 Что вам понадобится

- ✅ Аккаунт на GitHub
- ✅ Сервер (VPS) с Ubuntu/Debian
- ✅ 5 минут свободного времени

---

## 🚀 Шаг 1: Подготовка сервера (2 минуты)

Подключитесь к серверу и выполните:

```bash
# Подключение к серверу
ssh user@your-server-ip

# Запустите скрипт настройки (все установит автоматически)
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/actions/main/configs/server-setup.sh | sudo bash

# Или скачайте и запустите вручную:
# wget https://raw.githubusercontent.com/YOUR_USERNAME/actions/main/configs/server-setup.sh
# sudo bash server-setup.sh
```

Скрипт автоматически установит:
- Docker и Docker Compose
- Nginx (веб-сервер)
- Файрвол (UFW)
- Fail2ban (защита от брутфорса)

---

## 🔑 Шаг 2: Создание SSH ключа (1 минута)

На сервере выполните:

```bash
# Генерация SSH ключа
ssh-keygen -t ed25519 -C "github-actions" -f ~/.ssh/github_actions

# Добавление публичного ключа в authorized_keys
cat ~/.ssh/github_actions.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Скопируйте приватный ключ (понадобится для GitHub)
cat ~/.ssh/github_actions
```

**Важно:** Скопируйте весь вывод команды (включая `-----BEGIN` и `-----END`)

---

## 🔐 Шаг 3: Настройка GitHub Secrets (1 минута)

1. Перейдите в ваш репозиторий на GitHub
2. **Settings** → **Secrets and variables** → **Actions**
3. Нажмите **"New repository secret"**
4. Добавьте следующие секреты:

| Название | Значение | Пример |
|----------|----------|--------|
| `SSH_HOST` | IP адрес вашего сервера | `192.168.1.100` |
| `SSH_USERNAME` | Имя пользователя SSH | `ubuntu` |
| `SSH_PRIVATE_KEY` | Приватный SSH ключ | Вывод `cat ~/.ssh/github_actions` |
| `SSH_PORT` | Порт SSH (опционально) | `22` |

### Пример добавления секрета:

```
Name: SSH_HOST
Secret: 192.168.1.100
```

Нажмите **"Add secret"**

---

## 🎯 Шаг 4: Деплой! (1 минута)

Теперь просто запушьте код:

```bash
git add .
git commit -m "Setup CI/CD"
git push origin main
```

### Проверка деплоя:

1. Перейдите в **GitHub** → **Actions**
2. Вы увидите запущенный workflow "Build and Deploy"
3. Дождитесь зеленой галочки ✅

---

## ✅ Шаг 5: Проверка работы

```bash
# Проверка на сервере
ssh user@your-server-ip
docker ps  # Должен быть контейнер time-server-app

# Проверка API
curl http://your-server-ip:8000/health
curl http://your-server-ip:8000/time

# Или откройте в браузере:
# http://your-server-ip:8000/docs
```

---

## 🎉 Готово!

Теперь при каждом пуше в `main` ваше приложение будет автоматически обновляться на сервере!

---

## 🔄 Следующие шаги (опционально)

### 1. Настройка доменного имени

Если у вас есть домен, направьте его на IP сервера:

**DNS настройки:**
```
Type: A
Name: @
Value: YOUR_SERVER_IP
```

### 2. Настройка SSL (HTTPS)

```bash
# На сервере
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

Подробнее: [configs/SSL_SETUP.md](configs/SSL_SETUP.md)

### 3. Настройка Nginx

```bash
# Редактировать конфигурацию
sudo nano /etc/nginx/sites-available/time-server

# Активировать
sudo ln -s /etc/nginx/sites-available/time-server /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

Пример: [configs/nginx.conf](configs/nginx.conf)

---

## 🐛 Что-то пошло не так?

### GitHub Actions не запускается

- Проверьте, что workflow файл находится в `.github/workflows/deploy.yml`
- Убедитесь, что вы пушите в ветку `main` (или `master`)

### Ошибка SSH подключения

```bash
# На сервере проверьте SSH
cat ~/.ssh/authorized_keys
# Должен быть публичный ключ

# Локально проверьте подключение
ssh -i ~/.ssh/github_actions user@your-server-ip
```

### Контейнер не запускается

```bash
# На сервере проверьте логи
docker logs time-server-app

# Проверьте, что порт свободен
sudo lsof -i :8000
```

### Подробная документация

- 📖 [Полная инструкция](.github/DEPLOYMENT_SETUP.md)
- 📋 [Полезные команды](COMMANDS.md)
- 🔧 [Документация workflows](.github/README.md)

---

## 📊 Архитектура системы

```
┌─────────────┐
│   GitHub    │
│ Repository  │
└──────┬──────┘
       │ git push
       ▼
┌─────────────────────────────────────┐
│      GitHub Actions                 │
│  ┌──────────────────────────────┐   │
│  │  1. Build Docker Image       │   │
│  │  2. Push to GHCR             │   │
│  └──────────────────────────────┘   │
└──────────────┬──────────────────────┘
               │ SSH
               ▼
┌─────────────────────────────────────┐
│         Your Server                 │
│  ┌──────────────────────────────┐   │
│  │  3. Pull Image from GHCR     │   │
│  │  4. Stop Old Container       │   │
│  │  5. Start New Container      │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌──────────────────────────────┐   │
│  │     Docker Container         │   │
│  │   FastAPI App (port 8000)    │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌──────────────────────────────┐   │
│  │  Nginx (optional)            │   │
│  │  Reverse Proxy (port 80/443) │   │
│  └──────────────────────────────┘   │
└─────────────────────────────────────┘
               │
               ▼
         ┌───────────┐
         │   Users   │
         └───────────┘
```

---

## 💡 Полезные советы

1. **Используйте теги для версий:**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **Просматривайте логи деплоя:**
   - GitHub → Actions → выбрать последний run

3. **Мониторьте приложение:**
   ```bash
   docker logs -f time-server-app
   ```

4. **Быстрый откат:**
   ```bash
   docker pull ghcr.io/username/actions:v1.0.0
   docker stop time-server-app && docker rm time-server-app
   docker run -d --name time-server-app -p 8000:8000 ghcr.io/username/actions:v1.0.0
   ```

---

**🎊 Поздравляем! Вы настроили CI/CD для вашего проекта!**

Теперь каждое изменение автоматически доставляется на сервер. Больше никаких ручных деплоев! 🚀
