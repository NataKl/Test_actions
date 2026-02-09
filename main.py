from fastapi import FastAPI
from datetime import datetime
from typing import Dict
import uvicorn

app = FastAPI(
    title="Time Server API",
    description="Простой тестовый бэкенд для получения текущего времени сервера",
    version="1.0.0"
)


@app.get("/", tags=["General"])
async def root() -> Dict[str, str]:
    """
    Корневой endpoint приветствия
    """
    return {
        "message": "Добро пожаловать в Time Server API",
        "docs": "/docs",
        "current_time_endpoint": "/time"
    }


@app.get("/time", tags=["Time"])
async def get_server_time() -> Dict[str, str]:
    """
    Возвращает текущее время сервера
    
    Returns:
        Dict с текущим временем в различных форматах
    """
    now = datetime.now()
    
    return {
        "server_time": now.isoformat(),
        "formatted_time": now.strftime("%Y-%m-%d %H:%M:%S"),
        "date": now.strftime("%Y-%m-%d"),
        "time": now.strftime("%H:%M:%S"),
        "timestamp": int(now.timestamp())
    }


@app.get("/health", tags=["Health"])
async def health_check() -> Dict[str, str]:
    """
    Endpoint для проверки здоровья сервиса
    """
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat()
    }


if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )
