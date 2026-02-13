# 📦 Инструкция по настройке CI/CD

## 🔐 Настройка секретов в GitHub

Для работы workflow необходимо настроить следующие секреты в вашем репозитории:

### Как добавить секреты:
1. Перейдите в ваш репозиторий на GitHub
2. Settings → Secrets and variables → Actions
3. Нажмите "New repository secret"
4. Добавьте каждый из следующих секретов:

### Необходимые секреты:

| Секрет | Описание | Пример |
|--------|----------|--------|
| `SSH_HOST` | IP адрес или домен вашего сервера | `192.168.1.100` или `example.com` |
| `SSH_USERNAME` | Имя пользователя для SSH подключения | `root` или `ubuntu` |
| `SSH_PRIVATE_KEY` | Приватный SSH ключ для подключения | Содержимое файла `~/.ssh/id_rsa` |
| `SSH_PORT` | Порт SSH (опционально, по умолчанию 22) | `22` |

### 🔑 Генерация SSH ключа

Если у вас еще нет SSH ключа, сгенерируйте его:

```bash
# Локально на вашей машине
ssh-keygen -t ed25519 -C "github-actions" -f github_actions_key
```

Это создаст два файла:
- `github_actions_key` - приватный ключ (добавьте в секрет `SSH_PRIVATE_KEY`)
- `github_actions_key.pub` - публичный ключ (добавьте на сервер)

### 📤 Установка публичного ключа на сервер

```bash
# Подключитесь к вашему серверу
ssh user@your-server

# Добавьте публичный ключ в authorized_keys
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo "ваш_публичный_ключ" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

## 🐳 Подготовка сервера

Убедитесь, что на вашем сервере установлен Docker:

```bash
# Проверка установки Docker
docker --version

# Если Docker не установлен, установите его:
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Добавьте пользователя в группу docker (чтобы не использовать sudo)
sudo usermod -aG docker $USER
```

## 🚀 Как работает workflow

### Триггеры запуска:
- ✅ Push в ветку `main` или `master`
- ✅ Создание тега (например, `v1.0.0`)
- ✅ Ручной запуск через GitHub Actions UI

### Процесс деплоя:

1. **Build and Push** (Джоба 1):
   - Клонирование репозитория
   - Сборка Docker образа
   - Публикация образа в GitHub Container Registry (GHCR)
   - Теги: `latest`, `main-{sha}`, или версия из Git тега

2. **Deploy** (Джоба 2):
   - Подключение к серверу по SSH
   - Остановка старого контейнера
   - Скачивание нового образа из GHCR
   - Запуск нового контейнера
   - Проверка работоспособности приложения

## 📝 Пример использования

### Деплой через commit:
```bash
git add .
git commit -m "Update application"
git push origin main
```

### Деплой с версией:
```bash
git tag v1.0.0
git push origin v1.0.0
```

### Ручной деплой:
1. Перейдите в GitHub → Actions
2. Выберите workflow "Build and Deploy"
3. Нажмите "Run workflow"
4. Выберите ветку и запустите

## 🔍 Проверка работы

После деплоя проверьте работу приложения:

```bash
# На сервере
docker ps | grep time-server-app
docker logs time-server-app

# Извне (замените на IP вашего сервера)
curl http://your-server:8000/health
curl http://your-server:8000/time
```

## ⚙️ Настройка параметров

### Изменить порт приложения:
В файле `.github/workflows/deploy.yml` найдите строку:
```yaml
-p 8000:8000 \
```
Замените первое число на нужный порт (например, `-p 80:8000`)

### Изменить имя контейнера:
Найдите `time-server-app` и замените на желаемое имя.

### Добавить переменные окружения:
В секцию `docker run` добавьте:
```yaml
-e VARIABLE_NAME=value \
```

## 🛠️ Troubleshooting

### Ошибка "Permission denied" при SSH:
- Проверьте, что публичный ключ добавлен в `~/.ssh/authorized_keys` на сервере
- Проверьте права доступа: `chmod 600 ~/.ssh/authorized_keys`

### Ошибка "Cannot connect to Docker daemon":
- Убедитесь, что Docker запущен: `sudo systemctl start docker`
- Добавьте пользователя в группу docker: `sudo usermod -aG docker $USER`

### Порт 8000 уже занят:
- Измените порт в docker run команде: `-p 8001:8000`
- Или остановите другой сервис: `lsof -i :8000`

## 📚 Дополнительные ресурсы

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [Docker Documentation](https://docs.docker.com/)
