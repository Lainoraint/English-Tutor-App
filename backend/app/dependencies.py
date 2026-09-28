from fastapi import Header, HTTPException
from .config import settings
from .ratelimit import limiter

async def verify_request(
    x_app_token: str = Header(None, alias="X-App-Token"),
    x_device_id: str = Header(None, alias="X-Device-Id")
):
    if not x_app_token or x_app_token != settings.app_token:
        raise HTTPException(
            status_code=401, 
            detail={"error": {"code": "unauthorized", "message": "Invalid or missing app token"}}
        )
    
    if not x_device_id:
        raise HTTPException(
            status_code=400, 
            detail={"error": {"code": "bad_request", "message": "Missing device ID"}}
        )
        
    if not limiter.check_and_increment(x_device_id, settings.daily_limit):
        raise HTTPException(
            status_code=429, 
            detail={"error": {"code": "rate_limited", "message": "Daily limit reached. Please try again tomorrow."}}
        )
        
    return x_device_id
