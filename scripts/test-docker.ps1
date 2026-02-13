# Скрипт для локального тестирования Docker образа (Windows PowerShell)
# Использование: .\scripts\test-docker.ps1

$ErrorActionPreference = "Stop"

Write-Host "🐳 Тестирование Docker образа локально" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Имя образа и контейнера
$IMAGE_NAME = "time-server-local"
$CONTAINER_NAME = "time-server-test"
$PORT = "8000"

# Остановка и удаление старого контейнера (если есть)
Write-Host "🔧 Очистка старых контейнеров..." -ForegroundColor Yellow
docker stop $CONTAINER_NAME 2>$null
docker rm $CONTAINER_NAME 2>$null

# Сборка образа
Write-Host "🏗️  Сборка Docker образа..." -ForegroundColor Yellow
docker build -t $IMAGE_NAME .

# Запуск контейнера
Write-Host "🚀 Запуск контейнера..." -ForegroundColor Yellow
docker run -d --name $CONTAINER_NAME -p "${PORT}:8000" $IMAGE_NAME

# Ожидание запуска
Write-Host "⏳ Ожидание запуска приложения..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Проверка статуса
Write-Host "✅ Проверка статуса контейнера..." -ForegroundColor Green
docker ps | Select-String $CONTAINER_NAME

Write-Host ""
Write-Host "🧪 Тестирование endpoints..." -ForegroundColor Cyan
Write-Host "----------------------------" -ForegroundColor Cyan

Write-Host "1. Health check:" -ForegroundColor White
try {
    $response = Invoke-RestMethod -Uri "http://localhost:${PORT}/health" -Method Get
    $response | ConvertTo-Json
} catch {
    Write-Host "Ошибка при вызове health endpoint" -ForegroundColor Red
}

Write-Host ""
Write-Host "2. Root endpoint:" -ForegroundColor White
try {
    $response = Invoke-RestMethod -Uri "http://localhost:${PORT}/" -Method Get
    Write-Host "Message: $($response.message)"
} catch {
    Write-Host "Ошибка при вызове root endpoint" -ForegroundColor Red
}

Write-Host ""
Write-Host "3. Time endpoint:" -ForegroundColor White
try {
    $response = Invoke-RestMethod -Uri "http://localhost:${PORT}/time" -Method Get
    $response | ConvertTo-Json
} catch {
    Write-Host "Ошибка при вызове time endpoint" -ForegroundColor Red
}

Write-Host ""
Write-Host "4. Date endpoint:" -ForegroundColor White
try {
    $response = Invoke-RestMethod -Uri "http://localhost:${PORT}/date" -Method Get
    Write-Host "Date: $($response.date)"
    Write-Host "Day of week (RU): $($response.day_of_week_ru)"
} catch {
    Write-Host "Ошибка при вызове date endpoint" -ForegroundColor Red
}

Write-Host ""
Write-Host "✅ Все тесты пройдены!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Полезные команды:" -ForegroundColor Cyan
Write-Host "   Логи:          docker logs $CONTAINER_NAME" -ForegroundColor Gray
Write-Host "   Остановить:    docker stop $CONTAINER_NAME" -ForegroundColor Gray
Write-Host "   Удалить:       docker rm $CONTAINER_NAME" -ForegroundColor Gray
Write-Host ""
Write-Host "🌐 Swagger UI доступен по адресу: http://localhost:${PORT}/docs" -ForegroundColor Green
Write-Host ""
Write-Host "Нажмите любую клавишу для открытия Swagger UI в браузере..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Start-Process "http://localhost:${PORT}/docs"
