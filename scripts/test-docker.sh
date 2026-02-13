#!/bin/bash

# Скрипт для локального тестирования Docker образа
# Использование: ./scripts/test-docker.sh

set -e

echo "🐳 Тестирование Docker образа локально"
echo "========================================"

# Имя образа и контейнера
IMAGE_NAME="time-server-local"
CONTAINER_NAME="time-server-test"
PORT="8000"

# Остановка и удаление старого контейнера (если есть)
echo "🔧 Очистка старых контейнеров..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# Сборка образа
echo "🏗️  Сборка Docker образа..."
docker build -t $IMAGE_NAME .

# Запуск контейнера
echo "🚀 Запуск контейнера..."
docker run -d \
  --name $CONTAINER_NAME \
  -p $PORT:8000 \
  $IMAGE_NAME

# Ожидание запуска
echo "⏳ Ожидание запуска приложения..."
sleep 5

# Проверка статуса
echo "✅ Проверка статуса контейнера..."
docker ps | grep $CONTAINER_NAME

# Тестирование endpoints
echo ""
echo "🧪 Тестирование endpoints..."
echo "----------------------------"

echo "1. Health check:"
curl -s http://localhost:$PORT/health | jq .

echo ""
echo "2. Root endpoint:"
curl -s http://localhost:$PORT/ | jq .message

echo ""
echo "3. Time endpoint:"
curl -s http://localhost:$PORT/time | jq .

echo ""
echo "4. Date endpoint:"
curl -s http://localhost:$PORT/date | jq .date

echo ""
echo "✅ Все тесты пройдены!"
echo ""
echo "📝 Полезные команды:"
echo "   Логи:          docker logs $CONTAINER_NAME"
echo "   Остановить:    docker stop $CONTAINER_NAME"
echo "   Удалить:       docker rm $CONTAINER_NAME"
echo "   Открыть браузер: http://localhost:$PORT/docs"
echo ""
echo "🌐 Swagger UI доступен по адресу: http://localhost:$PORT/docs"
