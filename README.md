# Time Server API

Простое тестовое приложение на FastAPI, возвращающее текущее время сервера.

## Установка

1. Создайте виртуальное окружение:
```bash
python -m venv venv
```

2. Активируйте виртуальное окружение:
   - Windows:
     ```bash
     venv\Scripts\activate
     ```
   - Linux/Mac:
     ```bash
     source venv/bin/activate
     ```

3. Установите зависимости:
```bash
pip install -r requirements.txt
```

## Запуск

### Вариант 1: Через Python
```bash
python main.py
```

### Вариант 2: Через Uvicorn
```bash
uvicorn main:app --reload
```

Сервер запустится по адресу: `http://localhost:8000`

## API Endpoints

### 1. Корневой endpoint
**GET** `/`

Возвращает приветствие и информацию о доступных endpoints.

### 2. Получить время сервера
**GET** `/time`

Возвращает текущее время сервера в различных форматах:
- ISO 8601 формат
- Отформатированное время
- Дата
- Время
- Unix timestamp

**Пример ответа:**
```json
{
  "server_time": "2026-02-09T14:30:45.123456",
  "formatted_time": "2026-02-09 14:30:45",
  "date": "2026-02-09",
  "time": "14:30:45",
  "timestamp": 1770836445
}
```

### 3. Health Check
**GET** `/health`

Проверка здоровья сервиса.

## Интерактивная документация

После запуска сервера доступна автоматическая интерактивная документация:

- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## Технологии

- **FastAPI** - современный, быстрый веб-фреймворк для создания API
- **Uvicorn** - ASGI сервер для запуска приложения
- **Pydantic** - валидация данных

## Примеры использования

### cURL
```bash
curl http://localhost:8000/time
```

### Python requests
```python
import requests

response = requests.get("http://localhost:8000/time")
print(response.json())
```

### JavaScript fetch
```javascript
fetch('http://localhost:8000/time')
  .then(response => response.json())
  .then(data => console.log(data));
```

## 🐳 Docker

### Запуск через Docker

```bash
# Сборка образа
docker build -t time-server .

# Запуск контейнера
docker run -d -p 8000:8000 --name time-server time-server

# Просмотр логов
docker logs time-server

# Остановка контейнера
docker stop time-server
```

### Запуск через Docker Compose

```bash
# Запуск
docker-compose up -d

# Остановка
docker-compose down

# Просмотр логов
docker-compose logs -f
```

### Тестирование Docker локально

```bash
# Linux/macOS
./scripts/test-docker.sh

# Windows PowerShell
.\scripts\test-docker.ps1
```

## 🚀 CI/CD и автоматический деплой

Проект настроен для автоматического деплоя через **GitHub Actions**.

### Как это работает:

1. **При пуше в `main`** или создании тега:
   - Автоматически собирается Docker образ
   - Образ публикуется в GitHub Container Registry (GHCR)
   - Через SSH подключается к вашему серверу
   - Скачивает новый образ и запускает его

### Быстрый старт:

1. **Настройте секреты** в GitHub (Settings → Secrets):
   - `SSH_HOST` - IP адрес вашего сервера
   - `SSH_USERNAME` - имя пользователя SSH
   - `SSH_PRIVATE_KEY` - приватный SSH ключ
   - `SSH_PORT` - порт SSH (опционально, по умолчанию 22)

2. **Запушьте код**:
   ```bash
   git add .
   git commit -m "Deploy to production"
   git push origin main
   ```

3. **Готово!** GitHub Actions автоматически развернет приложение на вашем сервере.

### Документация по деплою:

- 📖 [Подробная инструкция по настройке](.github/DEPLOYMENT_SETUP.md)
- 📋 [Полезные команды](COMMANDS.md)
- 🔧 [Описание workflows](.github/README.md)

### Доступные workflows:

- **deploy.yml** - простой деплой через Docker команды (рекомендуется для начала)
- **deploy-compose.yml** - продвинутый деплой через Docker Compose

## 📊 Мониторинг

После деплоя проверьте работу приложения:

```bash
# На сервере
curl http://localhost:8000/health
curl http://localhost:8000/time

# Или откройте в браузере
# http://your-server-ip:8000/docs
```

## 📝 Разработка

### Структура проекта

```
Actions/
├── .github/
│   ├── workflows/
│   │   ├── deploy.yml              # Простой CI/CD workflow
│   │   └── deploy-compose.yml      # Продвинутый CI/CD workflow
│   ├── DEPLOYMENT_SETUP.md         # Инструкция по настройке
│   └── README.md                   # Описание workflows
├── scripts/
│   ├── test-docker.sh              # Тест Docker (bash)
│   └── test-docker.ps1             # Тест Docker (PowerShell)
├── main.py                         # Основной код приложения
├── Dockerfile                      # Конфигурация Docker образа
├── docker-compose.yml              # Docker Compose конфигурация
├── requirements.txt                # Python зависимости
├── COMMANDS.md                     # Полезные команды
└── README.md                       # Этот файл
```

## 🤝 Контрибьюция

Если вы хотите внести изменения:

1. Форкните репозиторий
2. Создайте ветку: `git checkout -b feature/amazing-feature`
3. Закоммитьте изменения: `git commit -m 'Add amazing feature'`
4. Запушьте ветку: `git push origin feature/amazing-feature`
5. Откройте Pull Request

## 📄 Лицензия

MIT License