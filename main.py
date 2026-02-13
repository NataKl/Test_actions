from fastapi import FastAPI
from datetime import datetime, timedelta
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
        "endpoints": {
            "time": "/time",
            "date": "/date",
            "today": "/date/today",
            "yesterday": "/date/yesterday",
            "tomorrow": "/date/tomorrow",
            "week": "/date/week",
            "month": "/date/month"
        }
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


@app.get("/date", tags=["Date"])
async def get_current_date() -> Dict[str, str]:
    """
    Возвращает текущую дату в различных форматах
    
    Returns:
        Dict с текущей датой в различных форматах
    """
    now = datetime.now()
    
    return {
        "date": now.strftime("%Y-%m-%d"),
        "date_formatted": now.strftime("%d.%m.%Y"),
        "date_long": now.strftime("%d %B %Y"),
        "day": now.strftime("%d"),
        "month": now.strftime("%m"),
        "year": now.strftime("%Y"),
        "day_of_week": now.strftime("%A"),
        "day_of_week_ru": ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"][now.weekday()],
        "week_number": now.strftime("%W"),
        "timestamp": int(now.timestamp())
    }


@app.get("/date/today", tags=["Date"])
async def get_today() -> Dict[str, str]:
    """
    Возвращает сегодняшнюю дату
    """
    today = datetime.now()
    
    return {
        "date": today.strftime("%Y-%m-%d"),
        "formatted": today.strftime("%d.%m.%Y"),
        "day_of_week": today.strftime("%A"),
        "day_of_week_ru": ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"][today.weekday()]
    }


@app.get("/date/yesterday", tags=["Date"])
async def get_yesterday() -> Dict[str, str]:
    """
    Возвращает вчерашнюю дату
    """
    yesterday = datetime.now() - timedelta(days=1)
    
    return {
        "date": yesterday.strftime("%Y-%m-%d"),
        "formatted": yesterday.strftime("%d.%m.%Y"),
        "day_of_week": yesterday.strftime("%A"),
        "day_of_week_ru": ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"][yesterday.weekday()]
    }


@app.get("/date/tomorrow", tags=["Date"])
async def get_tomorrow() -> Dict[str, str]:
    """
    Возвращает завтрашнюю дату
    """
    tomorrow = datetime.now() + timedelta(days=1)
    
    return {
        "date": tomorrow.strftime("%Y-%m-%d"),
        "formatted": tomorrow.strftime("%d.%m.%Y"),
        "day_of_week": tomorrow.strftime("%A"),
        "day_of_week_ru": ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"][tomorrow.weekday()]
    }


@app.get("/date/week", tags=["Date"])
async def get_week_info() -> Dict:
    """
    Возвращает информацию о текущей неделе
    """
    now = datetime.now()
    start_of_week = now - timedelta(days=now.weekday())
    end_of_week = start_of_week + timedelta(days=6)
    
    return {
        "current_date": now.strftime("%Y-%m-%d"),
        "week_number": now.strftime("%W"),
        "start_of_week": start_of_week.strftime("%Y-%m-%d"),
        "end_of_week": end_of_week.strftime("%Y-%m-%d"),
        "days_in_week": [
            (start_of_week + timedelta(days=i)).strftime("%Y-%m-%d") 
            for i in range(7)
        ]
    }


@app.get("/date/month", tags=["Date"])
async def get_month_info() -> Dict:
    """
    Возвращает информацию о текущем месяце
    """
    now = datetime.now()
    
    # Первый день месяца
    first_day = now.replace(day=1)
    
    # Последний день месяца
    if now.month == 12:
        last_day = now.replace(day=31)
    else:
        last_day = (now.replace(month=now.month + 1, day=1) - timedelta(days=1))
    
    return {
        "current_date": now.strftime("%Y-%m-%d"),
        "month": now.strftime("%m"),
        "month_name": now.strftime("%B"),
        "month_name_ru": ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", 
                          "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"][now.month - 1],
        "year": now.strftime("%Y"),
        "first_day": first_day.strftime("%Y-%m-%d"),
        "last_day": last_day.strftime("%Y-%m-%d"),
        "days_in_month": last_day.day
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
