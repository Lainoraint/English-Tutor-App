from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    gemini_api_key: str = ""
    gemini_model: str = "gemini-2.5-flash"
    daily_limit: int = 60
    app_token: str = "secret-token"

    class Config:
        env_file = ".env"

settings = Settings()
