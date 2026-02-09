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
