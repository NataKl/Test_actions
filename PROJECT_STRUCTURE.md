# 📁 Структура проекта

Полное описание структуры проекта и назначения каждого файла.

## 🌳 Дерево файлов

```
Actions/
│
├── 📂 .github/                           # GitHub специфичные файлы
│   ├── 📂 workflows/                     # GitHub Actions workflows
│   │   ├── deploy.yml                   # ⭐ Простой CI/CD (рекомендуется)
│   │   └── deploy-compose.yml           # 🚀 Продвинутый CI/CD с Docker Compose
│   ├── DEPLOYMENT_SETUP.md              # 📖 Подробная инструкция по настройке
│   └── README.md                        # 📋 Описание workflows
│
├── 📂 configs/                           # Конфигурационные файлы
│   ├── nginx.conf                       # 🌐 Пример конфигурации Nginx
│   ├── server-setup.sh                  # ⚙️ Скрипт автоматической настройки сервера
│   └── SSL_SETUP.md                     # 🔒 Инструкция по настройке SSL
│
├── 📂 scripts/                           # Вспомогательные скрипты
│   ├── test-docker.sh                   # 🧪 Тест Docker (Linux/macOS)
│   └── test-docker.ps1                  # 🧪 Тест Docker (Windows)
│
├── 📂 venv/                              # Виртуальное окружение Python (игнорируется)
│
├── 📄 main.py                            # 🐍 Основной код FastAPI приложения
├── 📄 Dockerfile                         # 🐳 Конфигурация Docker образа
├── 📄 docker-compose.yml                 # 🐳 Docker Compose конфигурация
├── 📄 requirements.txt                   # 📦 Python зависимости
│
├── 📄 .gitignore                         # 🚫 Игнорируемые файлы для Git
│
├── 📄 README.md                          # 📖 Основная документация
├── 📄 QUICKSTART.md                      # ⚡ Быстрый старт за 5 минут
├── 📄 COMMANDS.md                        # 📋 Полезные команды
├── 📄 CHEATSHEET.md                      # 📝 Шпаргалка
└── 📄 PROJECT_STRUCTURE.md               # 📁 Этот файл
```

## 📚 Описание файлов

### 🔥 Основные файлы для начала работы

| Файл | Описание | Приоритет |
|------|----------|-----------|
| **QUICKSTART.md** | Быстрый старт, настройка за 5 минут | 🔴 Начните отсюда |
| **.github/workflows/deploy.yml** | Основной CI/CD workflow | 🔴 Обязательно |
| **README.md** | Основная документация проекта | 🟡 Важно |

### 🛠️ CI/CD Workflows

| Файл | Описание | Когда использовать |
|------|----------|-------------------|
| **.github/workflows/deploy.yml** | Простой деплой через Docker команды | ✅ Для большинства случаев |
| **.github/workflows/deploy-compose.yml** | Деплой через Docker Compose | 🔧 Для сложных проектов |

**Как выбрать:**
- Начните с `deploy.yml`
- Переходите на `deploy-compose.yml` если нужны несколько сервисов (БД, Redis и т.д.)

### 📖 Документация

| Файл | Описание | Для кого |
|------|----------|----------|
| **README.md** | Основная документация, API endpoints | Все разработчики |
| **QUICKSTART.md** | Быстрая настройка деплоя за 5 минут | DevOps / Новички |
| **COMMANDS.md** | Подробные команды для работы | DevOps / Опытные |
| **CHEATSHEET.md** | Краткая шпаргалка команд | Все (для быстрого доступа) |
| **.github/DEPLOYMENT_SETUP.md** | Подробная настройка CI/CD | DevOps |
| **.github/README.md** | Описание workflows | DevOps |
| **configs/SSL_SETUP.md** | Настройка HTTPS сертификата | DevOps |
| **PROJECT_STRUCTURE.md** | Структура проекта (этот файл) | Все |

### ⚙️ Конфигурационные файлы

| Файл | Описание | Где использовать |
|------|----------|-----------------|
| **Dockerfile** | Конфигурация Docker образа | Локально + CI/CD |
| **docker-compose.yml** | Docker Compose конфигурация | Сервер (опционально) |
| **requirements.txt** | Python зависимости | Везде |
| **.gitignore** | Игнорируемые файлы | Git |
| **configs/nginx.conf** | Пример конфигурации Nginx | Сервер (копировать в `/etc/nginx/`) |

### 🚀 Скрипты

| Файл | Описание | Как запустить |
|------|----------|--------------|
| **scripts/test-docker.sh** | Тест Docker локально (Linux/macOS) | `./scripts/test-docker.sh` |
| **scripts/test-docker.ps1** | Тест Docker локально (Windows) | `.\scripts\test-docker.ps1` |
| **configs/server-setup.sh** | Автоматическая настройка сервера | `sudo bash server-setup.sh` |

### 🐍 Код приложения

| Файл | Описание |
|------|----------|
| **main.py** | FastAPI приложение |

## 🎯 Быстрая навигация

### Хочу начать с нуля
1. **QUICKSTART.md** - настройка за 5 минут
2. **.github/workflows/deploy.yml** - посмотрите CI/CD workflow
3. **README.md** - изучите API

### Уже работаю, нужна справка
- **CHEATSHEET.md** - краткая шпаргалка
- **COMMANDS.md** - все команды

### Настраиваю продакшен
1. **configs/server-setup.sh** - настройка сервера
2. **.github/DEPLOYMENT_SETUP.md** - настройка CI/CD
3. **configs/SSL_SETUP.md** - настройка HTTPS
4. **configs/nginx.conf** - настройка Nginx

### Проблемы с деплоем
- **.github/DEPLOYMENT_SETUP.md** - раздел Troubleshooting
- **COMMANDS.md** - раздел Troubleshooting
- **CHEATSHEET.md** - раздел Troubleshooting

## 📊 Workflow выполнения

### 1️⃣ Разработка

```
main.py → requirements.txt → Dockerfile
```

### 2️⃣ Локальное тестирование

```
scripts/test-docker.sh
или
scripts/test-docker.ps1
```

### 3️⃣ Git Push

```
git add . → git commit → git push
```

### 4️⃣ GitHub Actions (автоматически)

```
.github/workflows/deploy.yml
↓
1. Build Docker image
2. Push to GHCR
3. SSH to server
4. Deploy
```

### 5️⃣ Продакшен

```
Server → Docker Container → Nginx (опционально)
```

## 🔄 Жизненный цикл обновления

```
┌─────────────────────────────────────────────────────────────┐
│                    Локальная разработка                      │
│  main.py → test locally → git commit                        │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                         Git Push                             │
│  git push origin main                                       │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                     GitHub Actions                           │
│  ┌───────────────────────────────────────────────────┐     │
│  │ 1. Checkout code                                  │     │
│  │ 2. Build Docker image                             │     │
│  │ 3. Push to GitHub Container Registry (GHCR)      │     │
│  └───────────────────────────────────────────────────┘     │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    SSH Deploy to Server                      │
│  ┌───────────────────────────────────────────────────┐     │
│  │ 1. Connect via SSH                                │     │
│  │ 2. Login to GHCR                                  │     │
│  │ 3. Pull new image                                 │     │
│  │ 4. Stop old container                             │     │
│  │ 5. Start new container                            │     │
│  │ 6. Health check                                   │     │
│  └───────────────────────────────────────────────────┘     │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                          Production                          │
│  Application is live! 🎉                                    │
└─────────────────────────────────────────────────────────────┘
```

## 🎨 Цветовая легенда приоритетов

- 🔴 **Критично** - начните с этого
- 🟡 **Важно** - прочитайте обязательно
- 🟢 **Полезно** - пригодится позже
- ⚪ **Опционально** - по необходимости

## 📦 Размер файлов

| Тип файла | Размер | Примечание |
|-----------|--------|------------|
| Python код | ~6 KB | main.py |
| Docker образ | ~100-200 MB | В зависимости от зависимостей |
| Документация | ~50 KB | Все .md файлы |
| Скрипты | ~5 KB | test-docker, server-setup |

## 🔐 Файлы, которые НЕ нужно коммитить

Уже настроено в `.gitignore`:
- `venv/` - виртуальное окружение
- `*.pyc`, `__pycache__/` - скомпилированный Python
- `.env` - переменные окружения
- `github_ssh`, `*.pem`, `*.key` - SSH ключи
- `*.log` - логи

## 📝 Заметки

- Все workflow файлы YAML используют корректный синтаксис
- Все bash скрипты используют `set -e` для безопасности
- PowerShell скрипты используют `$ErrorActionPreference = "Stop"`
- Документация написана на русском языке для удобства

---

**💡 Совет:** Добавьте эту страницу в закладки для быстрой навигации по проекту!
