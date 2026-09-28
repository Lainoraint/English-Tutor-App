from fastapi import APIRouter, Depends
from ..models import ChatRequest, ChatResponse
from ..prompts import build_chat_prompt
from ..gemini import call_gemini
from ..dependencies import verify_request

router = APIRouter(prefix="/chat", dependencies=[Depends(verify_request)])

@router.post("", response_model=ChatResponse)
async def chat_endpoint(req: ChatRequest):
    sys_inst = build_chat_prompt(req.level, req.goal, req.explanation_language)
    
    user_content = "Conversation:\n"
    for msg in req.messages:
        user_content += f"{msg.role}: {msg.text}\n"
        
    return call_gemini(
        system_instruction=sys_inst,
        user_content=user_content,
        response_model=ChatResponse,
        temperature=0.7
    )
