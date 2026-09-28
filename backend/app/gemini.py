from typing import TypeVar, Type
from google import genai
from google.genai import types
from fastapi import HTTPException
from pydantic import BaseModel, ValidationError

from .config import settings

client = genai.Client(api_key=settings.gemini_api_key) if settings.gemini_api_key else None

T = TypeVar('T', bound=BaseModel)

def call_gemini(system_instruction: str, user_content: str, response_model: Type[T], temperature: float = 0.7) -> T:
    if not client:
        raise HTTPException(status_code=500, detail={"error": {"code": "ai_unavailable", "message": "API key not configured."}})
        
    config = types.GenerateContentConfig(
        system_instruction=system_instruction,
        temperature=temperature,
        response_mime_type="application/json",
        response_schema=response_model
    )
    
    attempts = 2
    for attempt in range(attempts):
        try:
            response = client.models.generate_content(
                model=settings.gemini_model,
                contents=user_content,
                config=config
            )
            
            if not response.text:
                raise ValueError("Empty response from AI")
            
            parsed = response_model.model_validate_json(response.text)
            return parsed
            
        except ValidationError as e:
            if attempt == attempts - 1:
                print(f"Validation Error on attempt {attempt+1}: {e}")
                raise HTTPException(status_code=502, detail={"error": {"code": "ai_invalid_output", "message": "The AI produced invalid output."}})
        except Exception as e:
            print(f"Gemini API Error: {e}")
            raise HTTPException(status_code=502, detail={"error": {"code": "ai_unavailable", "message": "Failed to communicate with AI service."}})
            
    raise HTTPException(status_code=502, detail={"error": {"code": "ai_invalid_output", "message": "The AI produced invalid output after retries."}})
